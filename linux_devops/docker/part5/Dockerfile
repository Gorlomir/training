FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    nginx \
    gcc \
    spawn-fcgi \
    libfcgi-dev \
    && rm -rf /var/lib/apt/lists/*

RUN find / -xdev -perm /6000 -type f -exec chmod a-s {} \; 2>/dev/null || true

WORKDIR /src/app
COPY server/ .

RUN gcc server.c -lfcgi -o server
COPY server/nginx/nginx.conf /etc/nginx/nginx.conf
HEALTHCHECK --interval=5m --timeout=3s \
  CMD curl -f http://localhost:81/status || exit 1
RUN useradd -d /home/nginx_user -m -s /bin/bash nginx_user
USER nginx_user
EXPOSE 8080
CMD spawn-fcgi -p 8080 -n ./server & nginx -g "daemon off;"