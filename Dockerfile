FROM dockerfile/nodejs

MAINTAINER Seid Adem, seid.adem@gmail.com


#========================================
# Add normal user with passwordless sudo
#========================================
RUN sudo useradd meanuser --shell /bin/bash --create-home \
  && sudo usermod -a -G sudo meanuser \
  && echo 'ALL ALL = (ALL) NOPASSWD: ALL' >> /etc/sudoers \
  && echo 'meanuser:secret' | chpasswd

WORKDIR /home/meanuser

# Install Mean.JS Prerequisites
RUN npm install -g grunt-cli
RUN npm install -g bower

# Install Mean.JS packages
ADD package.json /home/meanuser/package.json
RUN npm install

# Manually trigger bower. Why doesnt this work via npm install?
ADD .bowerrc /home/meanuser/.bowerrc
ADD bower.json /home/meanuser/bower.json
RUN bower install --config.interactive=false --allow-root

# Make everything available for start
ADD . /home/meanuser

# currently only works for development
ENV NODE_ENV development


# Port 3000 for server
EXPOSE 3030

RUN chmod +x /home/meanuser/bin/*.sh

CMD ["/home/meanuser/bin/entry_point.sh"]