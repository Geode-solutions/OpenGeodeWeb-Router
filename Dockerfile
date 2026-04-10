FROM nginx:alpine

RUN apk add python3 py3-pip supervisor
RUN pip3 install --break-system-packages google-cloud-run

COPY nginx.conf /etc/nginx/nginx.conf

COPY supervisord.conf /etc/supervisord.conf
RUN mkdir -p /var/log/supervisor

COPY cleanup_watcher.py /usr/local/bin/cleanup_watcher.py
RUN chmod +x /usr/local/bin/cleanup_watcher.py

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisord.conf"]