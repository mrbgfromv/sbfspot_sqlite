FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive
ENV SBFSPOT_HOME /home/sbfspot
ENV SMADATA /smadata
ENV SBFSPOTDIR /opt/sbfspot
ENV CONFIG /config

ARG user=sbfspot
ARG group=sbfspot
ARG uid=2000
ARG gid=2000

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${gid} ${group} \
&& useradd -d "$SBFSPOT_HOME" -u ${uid} -g ${gid} -m -s /bin/bash ${user}

RUN apt-get update \
&& apt-get install -y --no-install-recommends \
bluetooth \
libbluetooth-dev \
libboost-all-dev \
sqlite3 \
libsqlite3-dev \
libcurl3-dev \
default-libmysqlclient-dev \
make \
g++ \
git \
mercurial \
ca-certificates \
mosquitto-clients \
patch \
&& rm -rf /var/lib/apt/lists/*

RUN update-ca-certificates

# Make SBFspot and move installation to SBFSPOTDIR. SBFspot by default installs to /usr/local/bin/sbfspot.3
WORKDIR $SBFSPOT_HOME/
RUN git clone https://github.com/SBFspot/SBFspot.git

# Compile SBFspot
WORKDIR $SBFSPOT_HOME/SBFspot/SBFspot
RUN make sqlite \
&& make install_sqlite

# Compile SBFspotUploadDaemon
WORKDIR $SBFSPOT_HOME/SBFspot/SBFspotUploadDaemon
RUN make sqlite \
&& make install_sqlite

WORKDIR $SBFSPOT_HOME

# Deinstall compiler since we no longer need it
RUN apt-get -y purge \
g++ \
make \
mercurial \
git \
patch \
&& apt-get -y autoremove \
&& apt-get -y autoclean
 
RUN mv /usr/local/bin/sbfspot.3 $SBFSPOTDIR \
&& cp $SBFSPOT_HOME/SBFspot/SBFspot/CreateSQLiteDB.sql $SBFSPOTDIR \
&& cp $SBFSPOT_HOME/SBFspot/SBFspot/CreateMySQL*.sql $SBFSPOTDIR \
&& rm -rf $SBFSPOT_HOME/SBFspot

# Copy Startup-Script for the UploadDaemon
COPY start.sh $SBFSPOTDIR/
RUN chmod +x $SBFSPOTDIR/start.sh

# Setup data directory
RUN mkdir $SMADATA && chown -R ${user}:${group} $SMADATA
# Setup config directory
RUN mkdir $CONFIG && chown -R ${user}:${group} $CONFIG

VOLUME ["/smadata", "/config"]

USER ${user}

CMD [ "/opt/sbfspot/start.sh" ]
