FROM mhclg/foi-submissions-base

# allow access to port 3000
ENV APP_PORT 3000
EXPOSE $APP_PORT

# precompile assets
ARG RAILS_ENV=production
RUN RAILS_ENV=${RAILS_ENV} SECRET_KEY_BASE=$(bin/rake secret) bundle exec rake assets:precompile --trace

# run the rails server
ARG RAILS_ENV=production
CMD bundle exec rake db:migrate && bundle exec puma -C config/puma.rb -e ${RAILS_ENV} -p ${APP_PORT} -t 5:5
