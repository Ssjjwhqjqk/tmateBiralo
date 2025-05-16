FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y wget curl unzip openssh-client git python3 && \
    apt clean

# Download upterm
RUN wget https://github.com/owenthereal/upterm/releases/latest/download/upterm-linux-amd64 -O /usr/local/bin/upterm && \
    chmod +x /usr/local/bin/upterm

# Dummy web server to keep Render service alive
RUN mkdir -p /app && echo "Upterm session running..." > /app/index.html
WORKDIR /app

# Set the port to keep the container alive
EXPOSE 10000

# Command to launch dummy server and upterm session
CMD python3 -m http.server 10000 & \
    upterm host --force-command bash
