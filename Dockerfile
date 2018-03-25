FROM ubuntu:16.04

RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    apt-add-repository -y ppa:brightbox/ruby-ng && \
    apt-get update -y

RUN apt-get install -y \
      build-essential \
      ruby2.5 ruby2.5-dev \
      postgresql-client \
      libpq-dev \
      nodejs \
      unattended-upgrades \
      update-notifier-common \
      tzdata \
      graphicsmagick \
      libcurl3 \
      wget

ADD install_phantomjs.sh .
RUN bash install_phantomjs.sh

RUN gem install bundler

RUN mkdir -p /opt/big_earl

WORKDIR /opt/big_earl

ADD Gemfile      .
ADD Gemfile.lock .

ADD . .

ENV RAILS_ENV production
RUN bundle --without test development
RUN rails assets:precompile

ENV PORT 80
EXPOSE 80

ENTRYPOINT [ "rails", "server", "-b", "0.0.0.0", "-p", "80" ]
