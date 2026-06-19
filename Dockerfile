FROM ruby:4.0-slim

LABEL org.opencontainers.image.description="Build environment for progit2-ja (Japanese Pro Git v2 translation)"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    make \
    curl \
    unzip \
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

# Install HackGen Console fonts from GitHub releases.
# Pin with: docker build --build-arg HACKGEN_VERSION=vX.X.X .
ARG HACKGEN_VERSION
RUN HACKGEN_VER="${HACKGEN_VERSION:-$(curl -fsSL \
      https://api.github.com/repos/yuru7/HackGen/releases/latest \
      | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')}" \
 && echo "Installing HackGen Console ${HACKGEN_VER}" \
 && mkdir -p /usr/share/fonts/TTF /tmp/hackgen \
 && curl -fsSL \
     "https://github.com/yuru7/HackGen/releases/download/${HACKGEN_VER}/HackGenConsole_${HACKGEN_VER}.zip" \
     -o /tmp/hackgen.zip \
 && unzip -q /tmp/hackgen.zip -d /tmp/hackgen \
 && find /tmp/hackgen -name 'HackGenConsole-Regular.ttf' -exec cp {} /usr/share/fonts/TTF/ \; \
 && find /tmp/hackgen -name 'HackGenConsole-Bold.ttf' -exec cp {} /usr/share/fonts/TTF/ \; \
 && rm -rf /tmp/hackgen /tmp/hackgen.zip \
 && fc-cache -f

WORKDIR /build

# Pre-install gems as a cached layer.
# Gems live in the Ruby system dir, not /build, so a volume mount won't evict them.
COPY Gemfile Gemfile.lock ./
RUN bundle install

ENTRYPOINT ["make"]
CMD ["all"]
