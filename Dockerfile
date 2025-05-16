FROM almalinux:8

# Install EPEL and tmate dependencies
RUN yum install -y epel-release && \
    yum install -y tmate openssh-server python3 && \
    yum clean all

# Set up dummy web server folder
RUN mkdir -p /app && echo "Tmate session running" > /app/index.html
WORKDIR /app

# Expose a web port to keep Render container alive
EXPOSE 10000

# Run HTTP server in background, then start tmate
CMD python3 -m http.server 10000 & tmate -F
