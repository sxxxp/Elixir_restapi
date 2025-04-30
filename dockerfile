FROM elixir:latest

MAINTAINER sxxxp "junhyeonsin@gmail.com"

COPY mix.exs mix.lock ./
COPY lib ./lib
COPY config ./config
COPY test ./test
COPY chat_logs ./chat_logs

RUN apt-get update && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get

CMD ["mix", "run", "--no-halt"]
EXPOSE 4000
