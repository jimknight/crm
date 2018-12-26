# https://itnext.io/docker-rails-puma-nginx-postgres-999cd8866b18

FROM ruby:2.5.3

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    qt5-default \
    libqt5webkit5-dev \
    vim-gocomplete \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

# Postgres
RUN wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O - | apt-key add -
RUN sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'
RUN apt-get update
RUN apt-get install postgresql postgresql-contrib -y

# Set an environment variable where the Rails app is installed to inside of Docker image
ENV RAILS_ROOT /var/www/crm
RUN mkdir -p $RAILS_ROOT

# Set working directory
WORKDIR $RAILS_ROOT

# Setting env up
ENV RAILS_ENV='production'
ENV RACK_ENV='production'

# Adding gems
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

# Adding project files
COPY . .

# Start rails
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
