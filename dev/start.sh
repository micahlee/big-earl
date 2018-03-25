#!/bin/bash

docker-compose build
docker-compose up -d
docker-compose exec big-earl rails db:create db:migrate
docker-compose exec big-earl bash
