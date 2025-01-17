FROM archlinux:base-devel

ENV EDITOR=vim

RUN pacman -Syu --noconfirm
RUN pacman -S --noconfirm sudo git
RUN useradd -m builder -G wheel

COPY builder-sudoers-file /etc/sudoers.d/builder
COPY pacman.conf /etc/pacman.conf
COPY entrypoint.sh /usr/local/bin/

USER builder
RUN git config --global init.defaultBranch main
WORKDIR /home/builder/src
VOLUME /repo

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
