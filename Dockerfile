FROM ruby:2.7.1

ENV DEBIAN_FRONTEND=noninteractive

RUN sed -i '/deb-src/d' /etc/apt/sources.list && \
  apt-get update && \
  apt-get install -y build-essential apt-transport-https libpq-dev postgresql-client

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -

RUN apt-get update -qq && apt-get install -qq --no-install-recommends \
    nodejs \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN npm install -g yarn@1

WORKDIR /app

ADD . /app

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
