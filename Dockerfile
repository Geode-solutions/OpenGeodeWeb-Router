FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf

RUN \
    apt install openssl \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt
EXPOSE 443