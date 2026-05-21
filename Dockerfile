FROM python:3.12-slim
ENV LANG=C.UTF-8

# Common runtime deps
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libavcodec61 libavformat61 libavutil59 libswresample5 \
    libfftw3-double3 libfftw3-single3 libtag2 libsamplerate0 \
    libchromaprint1 libyaml-0-2 && \
    rm -rf /var/lib/apt/lists/*

# amd64: pre-built wheel from PyPI (fast)
# arm64: build from source (no PyPI wheel available)
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        pip install --no-cache-dir essentia; \
    else \
        apt-get update && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        build-essential python3-dev python3-setuptools pkg-config git ca-certificates \
        libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
        libavutil-dev libswresample-dev libsamplerate0-dev libtag-dev \
        libyaml-dev libchromaprint-dev && \
        update-ca-certificates --fresh && \
        pip install setuptools && \
        mkdir -p /tmp/build && cd /tmp/build && \
        git clone --depth 1 https://github.com/MTG/essentia.git && \
        cd essentia && \
        python3 waf configure --with-python && \
        python3 waf -j$(nproc) && \
        python3 waf install && \
        ldconfig && \
        cd / && rm -rf /tmp/build && \
        apt-get remove -y build-essential python3-dev python3-setuptools pkg-config git \
        libeigen3-dev libfftw3-dev libavcodec-dev libavformat-dev \
        libavutil-dev libswresample-dev libsamplerate0-dev libtag-dev \
        libyaml-dev libchromaprint-dev && \
        apt-get autoremove -y && \
        rm -rf /var/lib/apt/lists/* && \
        pip install --no-cache-dir numpy; \
    fi

ENV PYTHONPATH=/usr/local/lib/python3/dist-packages
WORKDIR /essentia
