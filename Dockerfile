FROM justbuchanan/docker-archlinux

RUN pacman -Syu --noconfirm

RUN pacman -S --noconfirm git ansible

COPY ./ dotfiles
WORKDIR dotfiles

RUN ./setup.sh

ENTRYPOINT ["/usr/bin/zsh"]
