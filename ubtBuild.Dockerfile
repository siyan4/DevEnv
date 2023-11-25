# 使用ARM64v8的Ubuntu 20.04镜像作为基础镜像
FROM arm64v8/ubuntu:20.04

# 设置中文环境变量
ENV LANG=C.UTF-8

ENV DEBIAN_FRONTEND=noninteractive
ADD qemu-aarch64-static /usr/bin

# 设置阿里云的软件源
#RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list && \
#    echo "deb-src http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list
# RUN sed -i s@/ports.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list

# 设置163的软件源
RUN sed -i 's/http:\/\/archive.ubuntu.com/http:\/\/mirrors.163.com/g' /etc/apt/sources.list 
RUN sed -i 's/http:\/\/security.ubuntu.com/http:\/\/mirrors.163.com/g' /etc/apt/sources.list 

RUN rm -rf /var/lib/apt/lists/* \
    && mkdir -p /var/lib/apt/lists/partial \
    && apt-get clean

# 更新软件包列表并安装基础软件和组件
RUN apt-get update && apt-get install -y \
    software-properties-common \
    build-essential \
    git \
    vim \
    curl \
    wget \
    tmux \
    lsb-release \
    unzip 

RUN apt-get -y install build-essential cmake g++ gcc \
    python3 python3-pip python3-setuptools \
    python3-opencv libhiredis-dev libjsoncpp-dev supervisor redis-tools


# 添加名为"ubt"的用户，密码为"123"
RUN useradd -m -s /bin/bash -p "$(openssl passwd -1 123)" ubt

# 设置默认工作目录
WORKDIR /home/ubt

# 切换到"ubt"用户
USER ubt

# 打开一个终端
CMD ["/bin/bash"]
