FROM debian:12@sha256:562665545b4070ef8d4e2fef66c9abc37a39b749f58a11bda5d7120f6cb327b3

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
