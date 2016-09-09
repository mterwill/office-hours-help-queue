FROM ruby:2.3.1
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs
RUN mkdir /eecshelp
WORKDIR /eecshelp
ADD Gemfile /eecshelp/Gemfile
ADD Gemfile.lock /eecshelp/Gemfile.lock
RUN bundle install
ADD . /eecshelp
