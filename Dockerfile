# Use the official Ubuntu base image
FROM ubuntu:latest

# Set non-interactive mode for apt-get
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
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

# Replace motd with a custom welcome message
RUN echo "Welcome to your VPS via tmate on Render!" > /etc/motd

# Enable root SSH login
RUN sed -i 's/#Port 22/Port 22/g' /etc/ssh/sshd_config && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/g' /etc/ssh/sshd_config && \
    echo 'root:123456' | chpasswd

# Add systemctl replacement for Docker environment
RUN curl -o /bin/systemctl https://raw.githubusercontent.com/gdraheim/docker-systemctl-replacement/master/files/docker/systemctl3.py && \
    chmod 775 /bin/systemctl

# Prepare HTML directory
RUN mkdir -p /var/www/html

# Replace default Nginx config
RUN echo 'server { listen 80; location / { root /var/www/html; try_files $uri $uri/ =404; } }' > /etc/nginx/sites-available/default

# Start services and expose port
EXPOSE 80

# Start script to run sshd, tmate session, and nginx
CMD bash -c "\
    systemctl start sshd && \
    tmate -F | tee /var/www/html/index.html & \
    nginx -g 'daemon off;'"
