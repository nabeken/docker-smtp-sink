FROM debian:12@sha256:6001f38763856a0181c479eb4844467ea3dcb843335e0d8404e6b366a271c9ae

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    curl \
    dumb-init \
    time \
    postfix && \
  apt-get clean && \
  apt-get autoremove -y && \
  rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN mkdir /sink && chown nobody:nogroup /sink
ADD ./run /usr/local/bin/run

EXPOSE 10025

USER nobody
VOLUME /sink

ENTRYPOINT ["/usr/bin/dumb-init", "--", "/usr/local/bin/run"]
