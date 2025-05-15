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
    echo 'root:BiraloSubscribe' | chpasswd

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
⚙️ 2. start.sh
bash
Copy
Edit
#!/bin/bash

# Start SSH
service ssh start

# Start tmate session in background socket mode
tmate -S /tmp/tmate.sock new-session -d

# Wait until the session is ready
while ! tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' > /dev/null 2>&1; do
  sleep 1
done

# Get session info
echo "🧑‍💻 Your VPS is ready!" > /var/www/html/index.html
echo "" >> /var/www/html/index.html
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}' >> /var/www/html/index.html
tmate -S /tmp/tmate.sock display -p '#{tmate_web}' >> /var/www/html/index.html

# Start web server
nginx -g 'daemon off;'
