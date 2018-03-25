#!/bin/bash

if [ ! -f key_base ]; then
	echo "Generating key base"
    od  -vN 64 -An -tx1 /dev/urandom | tr -d " \n" > key_base
fi

export BIG_EARL_KEY_BASE="$(cat key_base)"

docker-compose up -d
docker-compose exec big-earl rails db:create db:migrate
