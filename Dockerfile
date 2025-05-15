FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y tmate openssh-server nginx curl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Configure sshd
RUN mkdir /var/run/sshd && \
    sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    echo 'root:123456' | chpasswd

# Setup nginx to serve /var/www/html with inline config
RUN rm /etc/nginx/sites-enabled/default && \
    echo 'server { listen 80; root /var/www/html; index index.html; location / { try_files $uri $uri/ =404; } }' > /etc/nginx/sites-enabled/default

# Copy start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

EXPOSE 80 22

CMD ["/start.sh"]
