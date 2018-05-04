FROM ruby

RUN apt-get update -q \
    && apt-get install -y --no-install-recommends \
        doxygen \
        python-bs4 \
        python-lxml \
    && apt-get clean autoclean \
    && apt-get autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

# Init bundle dependencies
RUN git clone https://github.com/SEL4PROJ/docs.git \
    && cd docs \
    && bundle install \
    && cd / \
    && rm -rf docs
