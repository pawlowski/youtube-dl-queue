#!/bin/bash

# run this program and paste URLs of YouTube, Vimeo, etc. 
# and they will get downloaded automatically.

ROOT_DIR="$(dirname "$0")"
QUEUE_DIR="$(dirname $0)/queue"
mkdir -p "${QUEUE_DIR}"

echo -n "Automatically start the downloader on input? [Y/n] "
read download
if [ -z "${download}" ] ; then
  download="Y"
elif [ "${download}" = "y" ] ; then
  download="Y"
elif [ "${download}" = "yes" ] ; then
  download="Y"
fi

echo "Enter URLs of videos (CTRL-C to stop):"
while /bin/true ; do
  if [ "${download}" = "Y" ] ; then
    # start the downloader
    downloaders=$(ps -f | grep downloader.sh | wc -l)
    if [[ "${downloaders}" < 2 ]] ; then
      # downloader is not running, start it
      "${ROOT_DIR}/downloader.sh" &
    fi
  fi

  read u
  queue_file=$(mktemp --tmpdir="${QUEUE_DIR}" "url.$(date +%Y%m%d).XXXXXX")
  echo "${u}" > "${queue_file}"
done
