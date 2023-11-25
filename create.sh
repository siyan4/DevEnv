#!/bin/bash
#HOS
#

#podman build . -t debian:bookworm-systemd
#podman build --arch arm64 . -t ubuntu:focal-arm64

podman run --privileged --systemd always --name bookworm --network bridge -dit -p 10022:22 -v ~/.config/hostname:/etc/hostname localhost/debian:bookworm-systemd

podman run --privileged --systemd always --name Bookworm -dit -p 20022:22 -v ~/.config/hostname:/etc/hostname localhost/debian:bookworm-systemd

podman run --arch arm64 --privileged -p 30022:22 --env DISPLAY=unix:1 --env GDK_DPI_SCALE= --env GDK_SCALE= --name focal-arm64 --pull missing -u root -d -t -i -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/atom/CLionProjects/acu:/home/ubt/acu -v ~/.config/hostname:/etc/hostname ubuntu:focal-arm64

podman run --arch arm64 --privileged -p 2345:2345 --env DISPLAY=unix:1 --env GDK_DPI_SCALE= --env GDK_SCALE= --name uqiUbuntuV1 --pull missing -u root -d -t -i -v /usr/bin/qemu-aarch64-static:/usr/bin/qemu-aarch64-static -v /tmp/.X11-unix:/tmp/.X11-unix -v /home/atom/CLionProjects/acu:/home/ubt/acu localhost/uqiubuntu:v230921.0

exit

podman generate systemd --name focal-arm64 --files
sudo cp container-focal-arm64.service /usr/lib/systemd/user
systemctl --user daemon-reload
systemctl --user enable container-focal-arm64.service

#
#TOS
