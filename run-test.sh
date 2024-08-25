#!/bin/bash
die() {
  echo "NOT OK: ${@}" >&2
  exit 1
}

ok() {
  echo "OK: ${@}" >&2
}

RSYNC_HOST=rsync://127.0.0.1:10873

echo "Running the tests..."

docker compose -f compose-test.yaml up -d || die "unable to launch"

sleep 3

(echo 'quit' | nc 127.0.0.1 10025) || die "unable to connect"

UUID=$(uuidgen)

function testmail() {
  echo "EHLO localhost"

  sleep 1
  echo "MAIL FROM:<sender@example.com>"

  sleep 1
  echo "RCPT TO:<rcpt@example.com>"

  sleep 1
  echo "DATA"

  sleep 1
  echo "Sending data..." >&2

  echo "${UUID}"

  sleep 1
  echo "Sending dot..." >&2
  echo "."

  sleep 1
  echo "sending QUIT..." >&2
  echo "QUIT"
  sleep 1
}

function _nc() {
  case $(uname -s) in
    Darwin)
      nc -c "${@}"
      ;;
    *)
      nc -C "${@}"
      ;;
  esac
}

testmail | _nc 127.0.0.1 10025 || die "unable to send"

T=$(mktemp -d)
trap "rm -rf ${T}" EXIT

rsync -avP "${RSYNC_HOST}"/volume/ "${T}"

echo "test mail has been copied into ${T}"

grep "${UUID}" "${T}"/*
RET=$?

if [ $RET -eq 0 ]; then
  ok "test mail is ok"
else
  die "test mail isn't delivered"
fi

docker compose -f compose-test.yaml down --volumes || die "unable to terminate"
