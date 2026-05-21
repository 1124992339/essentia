FROM ubuntu:24.04
ENV LANG=C.UTF-8

RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 python3-numpy python3-six python3-yaml python3-matplotlib \
    libavcodec60 libavformat60 libavutil58 \
    libfftw3-3 libtag1v5 libsamplerate0 libchromaprint1 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential git python3-dev pkg-config \
    libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
    libavutil-dev libsamplerate0-dev libtag1-dev libyaml-dev \
    libchromaprint-dev && \
    mkdir -p /essentia && cd /essentia && \
    git clone https://github.com/MTG/essentia.git && \
    cd essentia && \
    python3 waf configure --with-python --with-examples --with-vamp && \
    python3 waf && \
    python3 waf install && \
    ldconfig && \
    apt-get remove -y build-essential git python3-dev pkg-config \
    libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
    libavutil-dev libsamplerate0-dev libtag1-dev libyaml-dev \
    libchromaprint-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /essentia/essentia

ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
WORKDIR /essentia
