#!/bin/bash
export TZ=Europe/Amsterdam
export TVHEADEND_CONFIG=/docker/data/tvheadend
export RECORDINGS_DIR=/mnt/recordings
export DOMAINNAME=thuis.local
env > .env
chmod 777 ${TVHEADEND_CONFIG}
docker compose up -d

