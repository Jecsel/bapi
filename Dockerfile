FROM ramelcabugos/biomark-booking-api:latest
ENV APP_HOME /app
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
RUN export RUBYOPT='-W:no-deprecated'
ADD . $APP_HOME
ENTRYPOINT ["docker-entrypoint.sh"]
