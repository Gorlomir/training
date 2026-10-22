FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    nginx \
    gcc \
    spawn-fcgi \
    libfcgi-dev \
    curl \
    && rm -rf /var/lib/apt/lists/* \
    && find / -xdev -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true \
    && useradd -d /home/nginx_user -m -s /bin/bash nginx_user \
    && mkdir -p /var/lib/nginx /var/lib/nginx/body /var/log/nginx /var/cache/nginx \
    && chown -R nginx_user:nginx_user /var/lib/nginx /var/log/nginx /var/cache/nginx \
    && chmod -R 755 /var/lib/nginx /var/log/nginx /var/cache/nginx

RUN find / -xdev -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true

WORKDIR /src/app
COPY server/ .

RUN gcc server.c -lfcgi -o server
COPY server/nginx/nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK --interval=5m --timeout=3s \
   CMD curl -f http://localhost:8080/ || exit 1
USER nginx_user
CMD spawn-fcgi -p 8080 -n ./server & nginx -g "daemon off;"