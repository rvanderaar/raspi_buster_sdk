FROM ubuntu:20.04

# Install some tools and compilers + clean up
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt-get update && \
    apt-get install -y rsync git wget cmake bzip2 sudo gdb-multiarch git && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

# Add a user called `develop`
RUN useradd -ms /bin/bash develop
RUN echo 'develop:develop' | chpasswd
RUN echo "develop   ALL=(ALL:ALL) ALL" >> /etc/sudoers

WORKDIR /home/develop

RUN cd /tmp && \
    wget https://github.com/Pro/raspi-toolchain/releases/latest/download/raspi-toolchain.tar.gz && \
    tar xzf raspi-toolchain.tar.gz --strip-components=1 -C /opt && \
    rm raspi-toolchain.tar.gz

# The ADD docker command wil automatically extract the tarbal
WORKDIR /home/develop
ADD rootfs.tgz raspi/

RUN cd /home/develop/raspi/rootfs && \
    ln -s usr/lib lib

RUN chown -R develop.develop raspi

USER develop
    