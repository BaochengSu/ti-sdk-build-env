FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list && \
#     sed -i "s@http://.*security.ubuntu.com@http://mirrors.huaweicloud.com@g" /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y locales && \
    localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

RUN dpkg --add-architecture i386 && apt-get update && \
    apt-get install -y git build-essential python \
    diffstat texinfo gawk chrpath dos2unix wget unzip \
    socat doxygen libc6:i386 libncurses5:i386 libstdc++6:i386 libz1:i386 sudo python3 cpio python3-distutils && \
    apt-get clean

# make /bin/sh symlink to bash instead of dash:
RUN echo "dash dash/sh boolean false" | debconf-set-selections
RUN dpkg-reconfigure dash

# set up git proxy
RUN wget -nv -O /usr/bin/oe-git-proxy "http://git.yoctoproject.org/cgit/cgit.cgi/poky/plain/scripts/oe-git-proxy" && \
    chmod +x /usr/bin/oe-git-proxy
ENV GIT_PROXY_COMMAND="oe-git-proxy"

# add new user
RUN adduser --disabled-password --gecos '' build && \
  usermod -aG sudo build && \
  echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

USER build 
ENV HOME /home/build
ENV LANG en_US.UTF-8

WORKDIR /home/build

RUN wget -q https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz && \
    wget -q https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz && \
    tar -Jxvf gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz -C $HOME && \
    tar -Jxvf gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz -C $HOME && \
    rm -r gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf.tar.xz && \
    rm -r gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu.tar.xz

ENV TOOLCHAIN_PATH_ARMV7=$HOME/gcc-arm-9.2-2019.12-x86_64-arm-none-linux-gnueabihf
ENV TOOLCHAIN_PATH_ARMV8=$HOME/gcc-arm-9.2-2019.12-x86_64-aarch64-none-linux-gnu

ENV MACHINE=am65xx-evm
