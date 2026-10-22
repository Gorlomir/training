FROM debian:bookworm-slim
RUN apt-get update && apt-get install -y \
    nginx \
    gcc \
    spawn-fcgi \
    libfcgi-dev
WORKDIR /src/app
COPY server/ .
RUN gcc server.c -lfcgi -o server
COPY server/nginx/nginx.conf /etc/nginx/nginx.conf
EXPOSE 8080
CMD spawn-fcgi -p 8080 -n ./server & nginx -g "daemon off;"