#!/bin/bash

set -e
set -u
#set -x

# This program will get started automatically by the enqueue.sh script.
starting=TRUE

YOUTUBE_DL_OPTIONS="--quiet -r 1M --restrict-filename --no-playlist --no-check-certificate --recode-video mp4"

ROOT_DIR="$(dirname "$0")"
QUEUE_DIR="${ROOT_DIR}/queue"
HOLDING_DIR="${ROOT_DIR}/holding"
mkdir -p "${HOLDING_DIR}"
DOWNLOAD_DIR="${ROOT_DIR}/download"
mkdir -p "${DOWNLOAD_DIR}"
ERROR_DIR="${ROOT_DIR}/error"

while /bin/true ; do
  # First check if there's a leftover URL in "holding"
  url_file=$(ls -tr "${HOLDING_DIR}" | head -1)
  if [ -z "${url_file}" ] ; then
    # Nothing in "holding", choose the oldest file to download first
    url_file=$(ls -tr "${QUEUE_DIR}" | head -1)
    if [ -z "${url_file}" ] ; then
      if [ "${starting}" != "TRUE" ] ; then
        echo "=> Queue is empty."
      fi
      exit 0
    fi
    mv "${QUEUE_DIR}/${url_file}" "${HOLDING_DIR}"
  fi

  if [ "${starting}" = "TRUE" ] ; then
    echo "=> Starting the downloader..."
    starting=FALSE
  fi

  url_to_download="$(cat "${HOLDING_DIR}/${url_file}")"
  echo "=> Starting download: ${url_to_download}"

  options="${YOUTUBE_DL_OPTIONS} -o ${DOWNLOAD_DIR}/%(title)s.%(id)s.%(ext)s"
  if youtube-dl ${options} "${url_to_download}" ; then
    # success! remove the URL from the queue
    echo "=> Success."
    rm -f "${HOLDING_DIR}/${url_file}"
  else
    # failure :( move to the error dir
    echo "=> Failure."
    mkdir -p "${ERROR_DIR}"
    mv "${HOLDING_DIR}/${url_file}" "${ERROR_DIR}"
  fi
done
