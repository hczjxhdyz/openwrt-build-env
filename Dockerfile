ARG BASE_IMAGE_TAG=22.04
FROM ubuntu:${BASE_IMAGE_TAG}

USER root


ARG DEPENDS_LIST="sudo apt-utils build-essential clang flex bison g++ gawk gettext \
git libncurses5-dev libssl-dev python3-distutils rsync unzip zlib1g-dev \
file wget golang libelf-dev qemu-utils"

RUN apt-get update  && \
    # apt-get upgrade && \
    apt-get install -y $DEPENDS_LIST && \
    apt-get clean && \
    useradd -m openwrt -s /bin/bash  && \
    echo 'openwrt ALL=NOPASSWD: ALL' > /etc/sudoers.d/openwrt && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* 
USER openwrt   
WORKDIR /home/openwrt
