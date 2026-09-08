FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive

# Bootstrap the user and the tools needed to clone and install the dotfiles.
RUN apt-get update \
    && apt-get install --yes --no-install-recommends \
        ca-certificates \
        git \
        sudo \
    && if ! id -u ubuntu >/dev/null 2>&1; then \
        useradd --create-home --shell /bin/bash ubuntu; \
    fi \
    && ubuntu_home="$(getent passwd ubuntu | cut -d: -f6)" \
    && ubuntu_group="$(id -gn ubuntu)" \
    && install --directory --owner=ubuntu --group="${ubuntu_group}" "${ubuntu_home}" \
    && printf '%s\n' 'ubuntu ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/ubuntu \
    && chmod 0440 /etc/sudoers.d/ubuntu \
    && visudo --check --file=/etc/sudoers.d/ubuntu

# install-linux uses apt directly. Keep its process running as ubuntu while
# allowing those package commands to use the temporary sudo configuration.
RUN printf '%s\n' \
        '#!/bin/sh' \
        'exec sudo /usr/bin/apt "$@"' \
        > /usr/local/bin/apt \
    && chmod 0755 /usr/local/bin/apt

USER ubuntu
WORKDIR /home/ubuntu

RUN git clone --depth 1 --branch main-2026 \
        https://github.com/pingtimeout/dotfiles.git \
        dotfiles \
    && ./dotfiles/install-linux

USER root

# Sudo is only needed during installation; do not leave it in the image.
RUN rm --force /usr/local/bin/apt /etc/sudoers.d/ubuntu \
    && SUDO_FORCE_REMOVE=yes apt-get purge --yes --auto-remove sudo \
    && rm --recursive --force /var/lib/apt/lists/*

USER ubuntu
