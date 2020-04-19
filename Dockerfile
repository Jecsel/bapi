FROM registry.gitlab.com/ramelcabugos/doctor-portal-api:BASE_latest
# FROM ruby:2.6.3
# RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
# RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
# RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn
# COPY docker-entrypoint.sh /usr/local/bin
# RUN chmod +x /usr/local/bin/docker-entrypoint.sh
# RUN mkdir $APP_HOME

#RUN gem install bundler:2.1.4

ENV APP_HOME /app
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/
RUN bundle install
RUN export RUBYOPT='-W:no-deprecated'
ADD . $APP_HOME
ENTRYPOINT ["docker-entrypoint.sh"]
