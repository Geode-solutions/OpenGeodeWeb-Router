FROM nginx:alpine
COPY nginx.conf /etc/nginx/nginx.conf

RUN \
    apk add openssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/nginx.key -out /etc/nginx/nginx.crt -subj "/C=FR/ST=France/L=Pau/O=Geode-solutions"


EXPOSE 80