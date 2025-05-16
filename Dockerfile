FROM ubuntu:22.04

# Install required packages
RUN apt update && \
    apt install -y wget curl git tmate neofetch python3 && \
    apt clean

# Create app directory and dummy index page
WORKDIR /app
RUN echo "Render tmate container running..." > index.html

# Copy the start script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Auto run neofetch when using shell
RUN echo "clear && neofetch" >> /root/.bashrc

# Expose port to prevent container from sleeping
EXPOSE 8080

# Start both tmate and the dummy web server
CMD ["/start.sh"]
