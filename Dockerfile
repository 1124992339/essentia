FROM ubuntu:20.04
ENV LANG=C.UTF-8

RUN apt-get update && apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    python3 python3-numpy python3-six python3-yaml python3-matplotlib \
    libavcodec58 libavformat58 libavutil56 libavresample4 \
    libfftw3-3 libtag1v5 libsamplerate0 libchromaprint1 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential git python3-dev pkg-config \
    libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
    libavutil-dev libavresample-dev libsamplerate0-dev libtag1-dev libyaml-dev \
    libchromaprint-dev ca-certificates && \
    update-ca-certificates --fresh && \
    mkdir -p /essentia && cd /essentia && \
    git clone --depth 1 https://github.com/MTG/essentia.git && \
    cd essentia && \
    python3 waf configure --with-python --with-examples --with-vamp && \
    python3 waf && \
    python3 waf install && \
    ldconfig && \
    apt-get remove -y build-essential git python3-dev pkg-config \
    libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
    libavutil-dev libavresample-dev libsamplerate0-dev libtag1-dev libyaml-dev \
    libchromaprint-dev && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/* /essentia/essentia

ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
WORKDIR /essentia
