FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y wget build-essential cmake git libjson-c-dev libwebsockets-dev libssl-dev zlib1g-dev && \
    apt install -y bash && \
    apt clean

# Clone and build ttyd
RUN git clone https://github.com/tsl0922/ttyd.git && \
    cd ttyd && mkdir build && cd build && \
    cmake .. && make && make install

# Expose the port Railway uses
EXPOSE 8080

# Start ttyd on port 8080 with bash
CMD ["ttyd", "-p", "8080", "bash"]
