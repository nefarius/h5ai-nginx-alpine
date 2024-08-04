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

# elevate permissions during image modification
USER root

RUN apk add --no-cache patch

# copy built h5ai dist
COPY --from=builder --chown=nobody /build/h5ai/build/_h5ai/ /usr/share/h5ai/_h5ai/

# apply patches
ADD class-setup.php.patch /tmp/class-setup.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /tmp/class-setup.php.patch; \
    rm -rf /tmp/*

    # h5ai-customized Nginx configuration
COPY default.conf /etc/nginx/conf.d/default.conf

# entrypoint script allows for easy debugging
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# drop privileges
USER nobody

EXPOSE 8080
VOLUME /data
WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["supervisord"]
