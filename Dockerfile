FROM debian:13@sha256:72547dd722cd005a8c2aa2079af9ca0ee93aad8e589689135feaed60b0a8c08d

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
