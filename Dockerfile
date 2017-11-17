FROM alpine:3.6
MAINTAINER Hugo Garbez <hugo.garbez@gmail.com>

RUN apk add --no-cache openssl patch; \
        wget https://release.larsjung.de/h5ai/h5ai-0.29.0.zip -P /tmp; \
        mkdir -p /usr/share/h5ai /data; \
        unzip /tmp/h5ai-0.29.0.zip -d /usr/share/h5ai

ADD class-setup.php.patch /tmp/class-setup.php.patch
RUN patch -p1 -u -d /usr/share/h5ai/_h5ai/private/php/core/ -i /tmp/class-setup.php.patch && rm -rf /tmp/*

RUN apk add --no-cache nginx \
                       php7-fpm \
                       php7-gd \
                       php7-exif \
                       php7-curl \
                       php7-iconv \
                       php7-xml \
                       php7-dom \
                       php7-json \
                       php7-zlib \
                       php7-session
COPY nginx-h5ai.conf /etc/nginx/nginx.conf

COPY options.json /usr/share/h5ai/_h5ai/private/conf/options.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh; \
        ln -sf /dev/stdout /var/log/nginx/access.log

EXPOSE 80
VOLUME /data
WORKDIR /data
ENTRYPOINT ["/entrypoint.sh"]
