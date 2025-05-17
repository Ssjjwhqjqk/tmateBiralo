FROM ubuntu:22.04

# Set environment variable for non-interactive installs
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt update && \
    apt install -y \
    wget curl git build-essential cmake \
    libjson-c-dev libwebsockets-dev libssl-dev \
    zlib1g-dev bash && \
    apt clean

# Build ttyd from source
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Create a non-root user for security
RUN useradd -m user
USER user
WORKDIR /home/user

# Expose port for Railway
EXPOSE 8080

# Start ttyd using bash
CMD ["ttyd", "-p", "8080", "bash"]
