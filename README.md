# DevEnv

The essential development environment for cross building UOS  packages in a container using arm64 virtual machine.

## Getting started

为了方便大家快速搭建交叉编译开发环境，这里给出一些必要操作步骤，请按下文进行。

本项目在`Debian GNU/Linux 12 (bookworm)`测试通过，其他操作系统平台可能存在较大差异，请按实际情况调整，如需帮助可以联系 [**陈思言**](mailto:siyan.chen@uqirobot.com)。

## 准备主机软件环境

- [ ] 安装QEMU软件：qemu-system qemu-user-static
- [ ] 注册QEMU环境：multiarch/qemu-user-static

```
sudo apt install --install-suggests podman podman-compose podman-docker podman-toolbox
docker run --rm --privileged multiarch/qemu-user-static:register --reset
sudo apt install --install-suggests qemu-system qemu-user-static
```

## 构建编译环境镜像

- [ ] [Ubuntu Docker Official Image](https://hub.docker.com/_/ubuntu)

```
#podman build . -t debian:bookworm-systemd
#podman build --arch arm64 . -t ubuntu:focal-arm64
ln -frs dockerfile.d/Dockerfile.focal.ubuntu dockerfile.d/Dockerfile
podman build --arch arm64 dockerfile.d -t ubuntu:devos-arm64
```

## 运行编译环境容器

```
sudo sysctl net.ipv4.ping_group_range='6    6'

podman run --arch arm64 --privileged --cap-add CAP_NET_RAW --systemd always --name DevEnv --network bridge -dit -p 10022:22 -p 2345:2345 -h devos --env DISPLAY=unix:1 --env GDK_DPI_SCALE= --env GDK_SCALE= --pull missing -u root -v ~/.config/hostname-devos:/etc/hostname -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/Projects:/home/ubt/Projects localhost/ubuntu:devos-arm64

podman generate systemd --name devos-arm64 --files
sudo cp container-devos-arm64.service /usr/lib/systemd/user
systemctl --user daemon-reload
systemctl --user enable container-devos-arm64.service
```

## 进入容器或者远程登录

```
podman attach focal-arm64 # root/root 退出容器：C-p,C-q
ssh root@localhost -p 10022 # root/root 注销登录：logout
```

## 直接加载镜像文件，然后运行容器

```
mkdir ~/Projects
gunzip devos-arm64.debian.tar.gz

docker load -i devos-arm64.debian.tar
touch ~/.config/hostname-devos

docker run --privileged --cap-add CAP_NET_RAW --name DevEnv --network bridge -dit -p 10022:22 -p 2345:2345 -h devos --env DISPLAY=unix:1 --env GDK_DPI_SCALE= --env GDK_SCALE= --pull missing -u root -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/Projects:/home/uqi/Projects localhost/debian:devos-arm64

# 连接容器方式
# 方式一：Attach
docker attach devos-arm64 # root/root 退出容器：C-p,C-q

# 方式二：SSH
#ssh root@localhost -p 10022 # root/root 注销登录：logout
```

## 请在下表添加新增软件依赖（软件包名，来源=apt|pip|local|other，版本，架构，是否安装，是否仅在开发环境安装，备注）

| Package Name                 | Source | Version           | Arch  | Installed | Devel Only | Remark                |
|------------------------------|--------|-------------------|-------|-----------|------------|-----------------------|
| ssh                          | apt    | 1:9.2p1-2+deb12u1 | all   | Yes       | No         |                       |
| uauto_v1.2.1_18.04_amd64.deb | local  | v1.2.1_18.04      | amd64 | No        | No         |                       |
| uauto_v1.2.1_18.04_arm64.deb | local  | v1.2.1_18.04      | arm64 | No        | No         |                       |
| uauto_v1.2.1_20.04_amd64.deb | local  | v1.2.1_20.04      | amd64 | No        | No         |                       |
| uauto_v1.2.1_20.04_arm64.deb | local  | v1.2.1_20.04      | arm64 | Yes       | No         | 需要Debian 12版本     |
| build-essential              | apt    | 12.9              | arm64 | Yes       | Yes        | 已包含gcc, make等工具 |
|                              |        |                   |       |           |            |                       |

***
