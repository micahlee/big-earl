# Big Earl

[![Build Status](https://travis-ci.org/micahlee/big-earl.svg?branch=master)](https://travis-ci.org/micahlee/big-earl)
[![Dependency Status](https://beta.gemnasium.com/badges/github.com/micahlee/big-earl.svg)](https://beta.gemnasium.com/projects/github.com/micahlee/big-earl)
[![Maintainability](https://api.codeclimate.com/v1/badges/15be40bda380df25f471/maintainability)](https://codeclimate.com/github/micahlee/big-earl/maintainability)


[![Docker Pulls](https://img.shields.io/docker/pulls/micahlee/big-earl.svg)](https://hub.docker.com/r/micahlee/big-earl/)


Big Earl exists to trim the fat from long URLs, making them easier and safer to share with others:

* Creates short alphabetic codes that redirect to the original URL

* Available through a JSON web service or web app

* Preview link destinations before navigating to unknown destinations for safer browsing

## Getting Started

There are a couple of different ways to try out Big Earl:

1. Cloud demo server

    You can access the a demo instance online at `https://big-earl.herokuapp.com/`

2. Run locally on Docker

    You can run Big Earl locally using Docker and Docker Compose:

    ```sh-session
   $ cd example
   $ ./start.sh
   ```

   This will pull the public docker image for Big Earl `micahlee/big-earl` and deploy
   it along with a postgres database locally. You can then access Big Earl at `http://localhost`.

   To stop Big Earl and clean up the containers, run:
   ```sh-session
   $ ./stop.sh
   ```

## Development

### Build Docker Image

Developing Big Earl requires Docker and Docker Compose.

1. Build the local development Docker image:
    
    ```sh-session
    $ ./build.sh
    ```
2. Start a local development container:

    ```sh-session
    $ cd dev/
    $ ./start.sh
    pg uses an image, skipping
    big-earl uses an image, skipping
    Creating dev_pg_1       ... done
    Creating network "dev_default" with the default driver
    Creating dev_big-earl_1 ... done
    Creating dev_big-earl_1 ... 
    Creating dev_cucumber_1 ... done
    Created database 'big_earl_dev'
    Created database 'big_earl_test'
    == 20180324012057 CreateShortLinks: migrating =================================
    -- create_table(:short_links)
    -> 0.0164s
    == 20180324012057 CreateShortLinks: migrated (0.0165s) ========================

    root@aaf1879d3e78:/src/big-earl# 
    ```

    This now leaves you with a shell in the development container, where you can run
    the usual rails commands (e.g. `bundle`, `rails s -b 0.0.0.0`).

    The default configuration for this container mounts the local source directory as
    a volume for the container. So changes you make to the source files will be 
    reflected in the development server running inside the container.

    The default configuration exposes port `3000` for the development site, so you
    can access the development instance at `http://localhost:3000`.

### Testing

Big Earl uses Cucumber tests, which require a running Big Earl server. If you use
the instructions above for running a development container you can also run the 
Cucumber tests against that same container with the server running inside.

Given that you are running Big Earl:

```sh-session
root@aaf1879d3e78:/src/big-earl# rails s -b 0.0.0.0
...
* Environment: development
* Listening on tcp://0.0.0.0:3000
Use Ctrl-C to stop
```

When you run Cucumber as a container:

```sh-session
$ cd dev/
$ ./cucumber.sh
```

Then you should get outcomes in your shell:

```sh-session
...
Feature: API to Shorten URL
    Big Earl supports creating a short URL by sending a POST
    request to the root path with a parameter containing the
    full URL to shorten

    Scenario: POST / to create a new short URL                     # features/api.feature:7
    When I successfully create a short URL for "http://google.com" # features/step_definitions/api_steps.rb:1
    Then the JSON should have "short_url"                          # json_spec-1.1.5/lib/json_spec/cucumber.rb:73
...
3 scenarios (3 passed)
11 steps (11 passed)
0m9.164s
```
