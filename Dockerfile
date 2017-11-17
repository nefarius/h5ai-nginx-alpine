FROM nginx:1.12-alpine
MAINTAINER Hugo Garbez <hugo.garbez@gmail.com>
ARG H5AI_VERSION=0.29.0

RUN apk add --no-cache openssl patch ffmpeg supervisor; \
    wget https://release.larsjung.de/h5ai/h5ai-${H5AI_VERSION}.zip -P /tmp; \
    mkdir -p /usr/share/h5ai /data; \
    unzip /tmp/h5ai-${H5AI_VERSION}.zip -d /usr/share/h5ai

ADD class-setup.php.patch /tmp/class-setup.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /tmp/class-setup.php.patch; \
    rm -rf /tmp/*

RUN apk add --no-cache php7-fpm \
                       php7-gd \
                       php7-exif \
                       php7-curl \
                       php7-iconv \
                       php7-xml \
                       php7-dom \
                       php7-json \
                       php7-zlib \
                       php7-session; \
                       rm -rf /var/cache/apk/*

RUN set -x; \
    addgroup -g 82 -S www-data; \
    adduser -u 82 -D -S -G www-data www-data

COPY php-fpm.conf /etc/php7/php-fpm.d/www.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY supervisord.conf /etc/supervisord.conf

EXPOSE 80
VOLUME /data
WORKDIR /data
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]
