FROM ruby:2.6-buster

# https://github.com/nodesource/distributions/blob/master/README.md#installation-instructions
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -

RUN apt-get update && apt-get install -y nodejs postgresql-contrib libpq-dev
ENV RAILS_ROOT /var/www/fb-publisher
RUN mkdir -p $RAILS_ROOT
WORKDIR $RAILS_ROOT

COPY Gemfile.lock Gemfile ./
RUN gem install bundler
ARG BUNDLE_FLAGS
RUN bundle install  --jobs 4 --retry 5 ${BUNDLE_FLAGS} \
                    --deployment \
                    --without development test

COPY . .

RUN groupadd -r deploy && useradd -m -u 1001 -r -g deploy deploy
RUN chown -R deploy:deploy .
USER 1001

ARG RAILS_ENV=production
