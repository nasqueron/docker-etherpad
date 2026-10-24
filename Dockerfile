#
# Docker image for Etherpad
#

FROM node:24-trixie

# Forked from Tony Motakis <tvelocity@gmail.com>
LABEL maintainer="Sébastien Santoro aka Dereckson <dereckson+nasqueron-docker@espace-win.org>"

ENV NODE_ENV=production
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        mariadb-client \
        git \
        sudo \
        libssl-dev \
        pkg-config \
        build-essential \
        libreoffice-writer \
        bash && \
    rm -rf /var/lib/apt/lists/*

RUN cd /opt && \
    git clone https://github.com/ether/etherpad-lite && \
    useradd --uid 9001 --create-home etherpad && \
    chown -R etherpad:0 /opt/etherpad-lite && \
    corepack enable && \
    corepack prepare pnpm@12.4.2 --activate

WORKDIR /opt/etherpad-lite
USER etherpad

RUN bin/installDeps.sh && \
    pnpm store prune && \
    rm -f settings.json

VOLUME /opt/etherpad-lite/var

RUN ln -s /opt/etherpad-lite/var/settings.json /opt/etherpad-lite/settings.json

COPY entrypoint.sh /

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "cd /opt/etherpad-lite/src && exec node --require tsx/cjs node/server.ts"]
