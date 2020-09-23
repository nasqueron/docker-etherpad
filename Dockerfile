#
# Docker image for Etherpad
#

FROM debian:buster

# Forked from Tony Motakis <tvelocity@gmail.com>
MAINTAINER Sébastien Santoro aka Dereckson <dereckson+nasqueron-docker@espace-win.org>

ENV NODE_ENV=production

RUN apt update && \
    apt install -y curl unzip mariadb-client git sudo python libssl-dev pkg-config build-essential abiword && \
    curl -sL https://deb.nodesource.com/setup_10.x | bash && \
    apt install -y nodejs && \
    rm -r /var/lib/apt/lists/*

RUN cd /opt && \
    git clone https://github.com/ether/etherpad-lite && \
    cd etherpad-lite && \
    bin/installDeps.sh && \
    rm settings.json

COPY entrypoint.sh /entrypoint.sh

VOLUME /opt/etherpad-lite/var

RUN ln -s /opt/etherpad-lite/var/settings.json /opt/etherpad-lite/settings.json

WORKDIR /opt/etherpad-lite
EXPOSE 9001
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bin/run.sh", "--root"]
