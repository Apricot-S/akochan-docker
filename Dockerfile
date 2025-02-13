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
        libboost-system-dev \
        make

RUN mkdir -p /opt && \
    chown -R ubuntu /opt

WORKDIR /opt

USER ubuntu

RUN mkdir build
RUN git clone https://github.com/critter-mj/akochan.git
RUN cd ./akochan/ai_src && \
    make -f Makefile_Linux && \
    cd ../ && \
    sed -i -e 's/boost::asio::io_service/boost::asio::io_context/' mjai_client.hpp && \
    sed -i -e 's/boost::asio::ip::address::from_string/boost::asio::ip::make_address/' mjai_client.cpp && \
    sed -i -e 's/boost::asio::buffer_cast<const char \*>(buffer\.data())/static_cast<const char *>(buffer.data().data())/' mjai_client.cpp && \
    make -f Makefile_Linux && \
    cp libai.so system.exe setup_match.json setup_mjai.json ../build && \
    cp -r params ../build

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

COPY --from=build --chown=ubuntu /opt/build /opt/akochan

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/akochan
