#!/bin/bash

# run this program and paste URLs of YouTube, Vimeo, etc. 
# and they will get downloaded automatically.

ROOT_DIR="$(dirname "$0")"
QUEUE_DIR="$(dirname $0)/queue"
mkdir -p "${QUEUE_DIR}"

#./downloader.sh

echo "Enter the URL of a video (CTRL-C to stop):"
while read u ; do
  queue_file=$(mktemp --tmpdir="${QUEUE_DIR}" "url.$(date +%Y%m%d).XXXXXX")
  echo "${u}" > "${queue_file}"

  # start the downloader
  downloaders=$(ps -f | grep downloader.sh | wc -l)
  if [[ "${downloaders}" < 2 ]] ; then
    # downloader is not running, start it
    "${ROOT_DIR}/downloader.sh" &
  fi
done
