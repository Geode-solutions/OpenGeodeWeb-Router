FROM nginx:alpine

RUN apk add curl jq bash supervisor

COPY nginx /etc/nginx

COPY supervisord /etc/supervisord
RUN mkdir -p /var/log/supervisor

COPY cleanup.bash /usr/local/bin/cleanup.bash
RUN chmod +x /usr/local/bin/cleanup.bash

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord/supervisord.conf"]