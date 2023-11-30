FROM debian AS builder
LABEL Description="Vita SDK Build Environment"

SHELL ["/bin/bash", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    curl \
    sudo \
    wget \
    bzip2 \
    xz-utils \
    python3 \
    file \
    libarchive-tools

RUN useradd --user-group --system --create-home --no-log-init --  vita
USER vita
ENV HOME /home/vita


FROM builder AS vitasdk-builder
ENV VITASDK=/usr/local/vitasdk

USER root

RUN cd $HOME && git clone https://github.com/vitasdk/vdpm && \
    cd vdpm && \
    ./bootstrap-vitasdk.sh

RUN cd $HOME/vdpm && ./install-all.sh
ENV PATH="${PATH}:/usr/local/vitasdk/bin"

USER vita

FROM vitasdk-builder AS vita-makepkg-builder
RUN cd $HOME && git clone https://github.com/vitasdk/vita-makepkg
ENV PATH="${PATH}:/root/vita-makepkg"