FROM ubuntu:14.04
MAINTAINER TANABE Ken-ichi <nabeken@tknetworks.org>

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    time \
    postfix && \
  apt-get clean autoclean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /sink && chown nobody:nogroup /sink
ADD ./run /usr/local/bin/run

EXPOSE 10025

USER nobody
VOLUME /sink

ENTRYPOINT ["/usr/local/bin/run"]
