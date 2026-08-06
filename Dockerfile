FROM nginx:alpine

RUN apk add curl jq bash supervisor

COPY nginx /etc/nginx

COPY supervisord/supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor
RUN mkdir -p /etc/supervisor/conf.d

COPY supervisord/conf.d /etc/supervisor/conf.d

COPY cleanup.bash /usr/local/bin/cleanup.bash
RUN chmod +x /usr/local/bin/cleanup.bash

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]