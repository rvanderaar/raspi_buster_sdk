FROM ubuntu:20.04


# Install some tools and compilers + clean up
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt-get update && \
    apt-get install -y rsync git wget cmake bzip2 && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop`
RUN useradd -ms /bin/bash develop
RUN echo "develop   ALL=(ALL:ALL) ALL" >> /etc/sudoers

WORKDIR /home/develop

RUN cd /tmp && \
    wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz && \
    tar xzf raspi-toolchain.tar.gz --strip-components=1 -C /opt && \
    rm raspi-toolchain.tar.gz

USER develop