FROM debian:13@sha256:9c6e381421d0f48d1b8133e573f33c185ee16cbf505eda9c4a8a4791b25ea8a6

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
