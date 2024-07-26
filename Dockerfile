FROM ubuntu:noble AS builder

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        g++ \
        git-core \
        libboost-all-dev \
        make && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt && \
    chown -R ubuntu /opt

WORKDIR /opt

USER ubuntu

RUN git clone https://github.com/critter-mj/akochan.git && \
    cd ./akochan/ai_src && \
    make -f Makefile_Linux && \
    cd ../ && \
    make -f Makefile_Linux

FROM ubuntu:noble AS runner

RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        libgomp1 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /opt && \
    chown -R ubuntu /opt

USER ubuntu

WORKDIR /opt/akochan

COPY --from=builder /opt/akochan /opt/akochan

ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/akochan
