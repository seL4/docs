FROM ruby

RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        doxygen \
        python3-bs4 \
        python3-lxml \
        python3-six \
        python3-jinja2 \
        python3-sh \
        python-pip \
        python3-pip \
        python3-pyelftools \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && pip3 install setuptools \
    && pip3 install aenum sortedcontainers pyyaml pyaml future \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Init bundle dependencies
RUN git clone https://github.com/SEL4PROJ/docs.git \
    && cd docs \
    && bundle install \
    && cd / \
    && rm -rf docs

# Jekyll will be serving on 127.0.0.1:4000
EXPOSE 4000
