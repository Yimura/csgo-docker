FROM debian:buster

ENV USER=csgo
ENV SRV_DIR=/srv

# setup sudo & allow using sudo without password
RUN apt update && apt install -y sudo && echo "%sudo ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# install basic file editor
RUN apt update && apt install -y nano

# enable 32bit packages and install required packages for steamcmd
RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y --no-install-recommends --no-install-suggests lib32gcc1 wget ca-certificates lib32stdc++6 locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninterfactive locales

# download steamcmd and install it
WORKDIR /tmp
RUN wget --quiet https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz && tar xf steamcmd_linux.tar.gz && cp -r /tmp/steamcmd.sh /tmp/linux32/ /usr/local/bin/ && chmod a+x -R /usr/local/bin/

# cleanup
RUN rm -rf /var/lib/apt/lists/*

# setup our user
RUN useradd $USER --create-home --shell /bin/bash --groups sudo

RUN mkdir --parents $SRV_DIR && chown $USER:$USER -R $SRV_DIR

WORKDIR /home/csgo

COPY start.sh .

RUN chown $USER:$USER -R .

ENTRYPOINT [ "bash", "start.sh" ]
