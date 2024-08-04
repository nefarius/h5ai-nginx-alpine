# h5ai-nginx-alpine

![Docker Image Version](https://img.shields.io/docker/v/containinger/h5ai-nginx-alpine)
![Docker Pulls](https://img.shields.io/docker/pulls/containinger/h5ai-nginx-alpine)

Docker build of h5ai web directory project.

Initially forked [from here](https://gitlab.com/Zaap59/h5ai-nginx-alpine/).

## Changes

- Updated to latest stable Nginx
- Adjusted build for changes of PHP 7 on Alpine
- Added extra access log file for logging behind a reverse proxy

## Building

```bash
docker build -t containinger/h5ai-nginx-alpine .
docker push containinger/h5ai-nginx-alpine
```

## Sources

- [h5ai fork](https://github.com/nefarius/h5ai)
- [Docker PHP-FPM 8.3 & Nginx 1.26 on Alpine Linux](https://github.com/TrafeX/docker-php-nginx)
