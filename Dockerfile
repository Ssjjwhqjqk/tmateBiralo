FROM ubuntu:22.04

# Install dependencies
RUN apt update && apt install -y \
    cmake g++ git libjson-c-dev libwebsockets-dev \
    make zlib1g-dev pkg-config libssl-dev wget curl

# Build ttyd from source
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Expose the port ttyd will run on
EXPOSE 8080

# Start ttyd on container start
CMD ["ttyd", "-p", "8080", "bash"]
