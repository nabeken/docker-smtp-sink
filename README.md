# docker-smtp-sink

docker-smtp-sink is docker container for smtp-sink and smtp-source.

## Expose

10025/tcp

## Volume

/sink for dumping

## Usage

See [smtp-sink(1)](http://www.postfix.org/smtp-sink.1.html) and [smtp-source(1)](http://www.postfix.org/smtp-source.1.html)

Launch a smtp-sink container.

```sh
docker run \
  -it \
  --rm \
  --name sink \
  nabeken/docker-smtp-sink -v -h mx.example.com -m 100 :10025 100
```

To send messages to this container, you can use special command with linking to the container:

```sh
docker run \
  -it \
  --rm \
  --link sink:sink \
  nabeken/docker-smtp-sink \
  smtp-source -c -s 100 -m 1000 -f from@example.com -t to@example.com -M smtp.example.com
```

You don't need to specify an address to smtp-source command since
docker-smtp-sink can detect the address automatically if a container is linking to smtp-source.
