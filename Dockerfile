FROM ruby:2.6.3
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /usr/src/eecshelp
WORKDIR /usr/src/eecshelp
ADD Gemfile /usr/src/eecshelp/Gemfile
ADD Gemfile.lock /usr/src/eecshelp/Gemfile.lock
RUN bundle install
ADD . /usr/src/eecshelp
