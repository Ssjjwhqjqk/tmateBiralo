FROM ubuntu:latest

ENV DEBIAN_FRONTEND=noninteractive

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    tmate \
    nginx \
    python3 \
    neofetch \
    nano \
    iproute2 \
    curl \
    wget \
    git \
    make \
    openssh-server && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /root

# Custom welcome message
RUN echo "Welcome to your VPS via tmate on Render!" > /etc/motd

# SSH server setup
RUN sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo 'root:123456' | chpasswd

# Prepare web directory
RUN mkdir -p /var/www/html

# Replace default Nginx config
RUN echo 'server { listen 80; location / { root /var/www/html; try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose HTTP port
EXPOSE 80

# Start script
CMD ["/start.sh"]
