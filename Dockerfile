# https://www.youtube.com/watch?v=dF6VQOZPZBM&t=680s

FROM ruby:2.5.3

RUN apt-get update -yqq \
  && apt-get install -yqq --no-install-recommends \
    build-essential \
    libpq-dev \
    nodejs \
    qt5-default \
    libqt5webkit5-dev \
    postgresql-client \
  && apt-get -q clean \
  && rm -rf /var/lib/apt/lists

WORKDIR /app
ADD Gemfile* ./
RUN bundle install
COPY . .

# https://youtu.be/3aal4zlBi5w?t=1230
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
