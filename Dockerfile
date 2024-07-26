# syntax=docker/dockerfile:1

FROM ubuntu:noble AS base

FROM base AS build

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        g++ \
        git-core \
        libboost-all-dev \
        make

RUN mkdir -p /opt && \
    chown -R ubuntu /opt

WORKDIR /opt

USER ubuntu

RUN git clone https://github.com/critter-mj/akochan.git
RUN cd ./akochan/ai_src && \
    make -f Makefile_Linux && \
    cd ../ && \
    make -f Makefile_Linux

FROM base AS final

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    rm -f /etc/apt/apt.conf.d/docker-clean; \
    echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libgomp1 && \
    mkdir -p /opt && \
    chown -R ubuntu /opt

WORKDIR /opt/akochan

USER ubuntu

COPY --from=build --chown=ubuntu /opt/akochan /opt/akochan

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/akochan
