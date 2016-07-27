#FROM dockerfile/nodejs
#FROM readytalk/nodejs
FROM ubuntu:14.04

MAINTAINER Seid Adem, seid.adem@gmail.com

RUN apt-get update && apt-get upgrade -y
RUN apt-get install build-essential openssl libssl-dev curl

#========================================
# Add normal user with passwordless sudo
#========================================
RUN sudo useradd meanuser --shell /bin/bash --create-home \
  && sudo usermod -a -G sudo meanuser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'meanuser:secret' | chpasswd

WORKDIR /home/meanuser

# Install Mean.JS Prerequisites
RUN apt-get install -y git git-core wget zip npm
RUN apt-get -y install nodejs-legacy

# compatibility fix for node on ubuntu
RUN ln -s /usr/bin/nodejs /usr/bin/node;

# install nvm
RUN curl https://raw.githubusercontent.com/creationix/nvm/v0.24.1/install.sh | sh;

ENV NVM_DIR /usr/local/nvm
ENV NODE_VERSION 6.1.0

# invoke nvm to install node
RUN cp -f ~/.nvm/nvm.sh ~/.nvm/nvm-tmp.sh; \
    echo "nvm install NODE_VERSION; nvm alias default $NODE_VERSION" >> ~/.nvm/nvm-tmp.sh; \
    sh ~/.nvm/nvm-tmp.sh; \
    rm ~/.nvm/nvm-tmp.sh;

RUN npm install -g grunt-cli \
                    bower \
                    yo

# Install Mean.JS packages
ADD package.json /home/meanuser/package.json
RUN npm install

# Manually trigger bower. Why doesnt this work via npm install?
ADD .bowerrc /home/meanuser/.bowerrc
ADD bower.json /home/meanuser/bower.json

# ADD .bowerrc .bowerrc
ADD bower.json /home/meanuser/bower.json
# RUN bower install
RUN bower install --config.interactive=false --allow-root

# Make everything available for start
ADD . /home/meanuser

# currently only works for development
ENV NODE_ENV development


# Port 3000 for server
EXPOSE 3030

RUN chmod +x /home/meanuser/bin/*.sh

CMD ["/home/meanuser/bin/entry_point.sh"]
