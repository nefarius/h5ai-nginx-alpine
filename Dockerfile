# pull and build https://github.com/nefarius/h5ai
FROM node:lts-slim AS builder

ENV NODE_OPTIONS=--openssl-legacy-provider
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /build

RUN apt update && \
    apt install git -y && \
    git clone https://github.com/nefarius/h5ai.git
WORKDIR /build/h5ai

RUN npm install && \
    npx --yes browserslist@latest --update-db && \
    npm run build


# build final image
FROM trafex/php-nginx AS final
LABEL maintainer="Benjamin Höglinger-Stelzer <nefarius@dhmx.at>"
ARG H5AI_VERSION=0.32.0

# elevate permissions during image modification
USER root

RUN apk add --no-cache patch

# copy built h5ai dist
COPY --from=builder /build/h5ai/build/_h5ai/ /usr/share/h5ai/_h5ai/

# apply patches
ADD class-setup.php.patch /tmp/class-setup.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /tmp/class-setup.php.patch; \
    rm -rf /tmp/*

#COPY php-fpm.conf /etc/php7/php-fpm.d/www.conf
#COPY nginx.conf /etc/nginx/nginx.conf
#COPY supervisord.conf /etc/supervisord.conf

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

USER nobody

EXPOSE 8080
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord"]
