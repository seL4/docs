# Copyright 2020 Data61, CSIRO
# SPDX-License-Identifier: BSD-2-Clause

FROM ruby:2

RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        doxygen \
        python3-dev \
        python3-bs4 \
        python3-lxml \
        python3-six \
        python3-jinja2 \
        python3-sh \
        python3-pip \
        python3-pyelftools \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && pip3 install setuptools camkes-deps \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Init bundle dependencies
RUN git clone https://github.com/seL4/docs.git \
    && cd docs \
    && bundle install \
    && cd / \
    && rm -rf docs

RUN curl -sSf https://sh.rustup.rs \
        | bash -s -- -y --no-modify-path

ENV PATH=/root/.cargo/bin:$PATH

RUN cargo install mdbook@0.4.36

RUN mkdir -p /opt/microkit/sdk \
    && curl -L https://github.com/seL4/microkit/releases/download/1.4.1/microkit-sdk-1.4.1-linux-x86-64.tar.gz \
        | tar -xzf - -C /opt/microkit/sdk --strip-components=1

RUN mkdir -p /opt/seL4 && ln -s /opt/microkit/sdk/board/qemu_virt_aarch64/debug/ /opt/seL4/libsel4

RUN git config --global --add safe.directory '/docs'

# Jekyll will be serving on 127.0.0.1:4000
EXPOSE 4000
