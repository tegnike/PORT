# use ruby version 2.5.3
FROM ruby:2.5.3

# using japanese on rails console
ENV LANG C.UTF-8

# remove warn
ENV DEBCONF_NOWARNINGS yes
ENV APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE yes
ENV XDG_CACHE_HOME /tmp

# install package to docker container
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    vim \
    less

# install yarn
RUN apt-get install apt-transport-https
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update && apt-get install -y yarn

# install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash -
RUN apt-get install -y nodejs

# setting environment value
ENV HOME /app
ARG RAILS_ENV
ARG RAILS_MASTER_KEY
ENV RAILS_ENV ${RAILS_ENV}
ENV RAILS_MASTER_KEY ${RAILS_MASTER_KEY}

# setting work directory
RUN mkdir $HOME
WORKDIR $HOME

# executing bundle install
COPY Gemfile $HOME/Gemfile
COPY Gemfile.lock $HOME/Gemfile.lock

RUN gem install bundler -v 2.0.2 && \
    bundle config --global build.nokogiri --use-system-libraries && \
    bundle install --path=vendor/bundle --jobs 4

ADD . $HOME
EXPOSE 3000
RUN /bin/sh -c bundle exec rails assets:precompile
