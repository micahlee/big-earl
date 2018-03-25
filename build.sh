#!/bin/bash

docker build -t big-earl .

docker build -t big-earl-dev -f Dockerfile.dev .
