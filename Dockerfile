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
    chown -R etherpad:0 /opt/etherpad-lite && \
    npm install npm@6 -g

WORKDIR /opt/etherpad-lite
USER etherpad

RUN src/bin/installDeps.sh && \
    rm -rf ~/.npm && \
    rm settings.json

USER root
RUN cd src && npm link
USER etherpad

VOLUME /opt/etherpad-lite/var

RUN ln -s /opt/etherpad-lite/var/settings.json /opt/etherpad-lite/settings.json

EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["etherpad"]
