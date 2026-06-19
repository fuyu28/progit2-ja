FROM ruby:4.0-slim

LABEL org.opencontainers.image.description="Build environment for progit2-ja (Japanese Pro Git v2 translation)"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    git \
    make \
    fontconfig \
    fonts-ipafont \
  && rm -rf /var/lib/apt/lists/*

# progit-theme.yml expects fonts at /usr/share/fonts/OTF/ (Arch Linux layout).
# Debian installs IPA fonts elsewhere, so create symlinks.
RUN mkdir -p /usr/share/fonts/OTF \
 && ln -sf "$(find /usr/share/fonts -name 'ipam.ttf' ! -path '*/OTF/*' | head -1)" \
           /usr/share/fonts/OTF/ipam.ttf \
 && ln -sf "$(find /usr/share/fonts -name 'ipag.ttf' ! -path '*/OTF/*' | head -1)" \
           /usr/share/fonts/OTF/ipag.ttf


WORKDIR /build

# Pre-install gems as a cached layer.
# Gems live in the Ruby system dir, not /build, so a volume mount won't evict them.
COPY Gemfile Gemfile.lock ./
RUN bundle install

ENTRYPOINT ["make"]
CMD ["all"]
