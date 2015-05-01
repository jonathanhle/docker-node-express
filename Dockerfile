# Docker node app container

FROM ubuntu:latest
MAINTAINER  Jonathan Le "jonathan.hle@gmail.com"

RUN apt-get update -y && \
        apt-get upgrade -y && \
        apt-get install -y git nodejs npm && \
	apt-get install -y supervisor

RUN ln -s `which nodejs` /usr/local/bin/node

# Set an utf-8 locale
RUN echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale
RUN locale-gen en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

# Get the latest app and then start it
ADD start.sh /tmp/
RUN chmod +x /tmp/start.sh
CMD ./tmp/start.sh && \
# start supervisord when container launches
	/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf 	
