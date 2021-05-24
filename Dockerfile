FROM ubuntu:20.04

# Install some tools and compilers + clean up
ARG DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Amsterdam
RUN apt-get update && \
    apt-get install -y rsync git wget cmake bzip2 sudo gdb-multiarch debootstrap && \
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

RUN mkdir -p /home/develop/rootfs/buster-armhf && \
    debootstrap --arch=armhf --variant=minbase --foreign --no-check-gpg buster /home/develop/rootfs/buster-armhf http://raspbian.raspberrypi.org/raspbian && \
    chroot /home/develop/rootfs/buster-armhf /debootstrap/debootstrap --second-stage

RUN chroot /home/develop/rootfs/buster-armhf apt-get update && \
    chroot /home/develop/rootfs/buster-armhf apt-get install -y  apt-utils libpigpio-dev libpigpiod-if-dev

COPY gdbinit /home/develop/.gdbinit

USER develop
    