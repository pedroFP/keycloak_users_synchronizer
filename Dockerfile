FROM ruby:3.3-slim AS build

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends build-essential libssl-dev && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

# ──────────────────────────────────────────────
FROM ruby:3.3-slim AS runtime

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends libssl3 && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /app .

RUN chmod +x bin/start

ENV KARAFKA_ENV=production

CMD ["bin/start"]
