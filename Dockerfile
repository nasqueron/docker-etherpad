#
# Docker image for Etherpad
#

FROM debian:bookworm

# Forked from Tony Motakis <tvelocity@gmail.com>
MAINTAINER Sébastien Santoro aka Dereckson <dereckson+nasqueron-docker@espace-win.org>

ENV NODE_ENV=production

RUN apt update && \
    apt install -y curl unzip mariadb-client git sudo libssl-dev pkg-config build-essential abiword && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash && \
    apt install -y nodejs && \
    rm -r /var/lib/apt/lists/*

RUN cd /opt && \
    git clone https://github.com/ether/etherpad-lite && \
    useradd --uid 9001 --create-home etherpad && \
    chown -R etherpad:0 /opt/etherpad-lite

WORKDIR /opt/etherpad-lite
USER etherpad

RUN bin/installDeps.sh && \
    rm -rf ~/.npm/_cacache && \
    rm settings.json

COPY entrypoint.sh /entrypoint.sh

VOLUME /opt/etherpad-lite/var

RUN ln -s /opt/etherpad-lite/var/settings.json /opt/etherpad-lite/settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["node", "node_modules/ep_etherpad-lite/node/server.js"]
