#!/bin/bash

# run this program and paste URLs of YouTube, Vimeo, etc. 
# and they will get downloaded automatically.

# start the downloader:
#./downloader.sh

# wait for input
QUEUE_DIR="$(dirname $0)/queue"
mkdir -p "${QUEUE_DIR}"

while read u ; do
  queue_file=$(mktemp --tmpdir="${QUEUE_DIR}" "url.$(date +%Y%m%d).XXXXXX")
  echo "${u}" > "${queue_file}"
done
