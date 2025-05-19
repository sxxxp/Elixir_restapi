FROM elixir:latest

MAINTAINER sxxxp "junhyeonsin@gmail.com"

COPY mix.exs mix.lock ./
COPY lib ./lib
COPY config ./config

COPY chat_logs ./chat_logs
COPY priv ./priv
RUN apt-get update && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get && \
    mix ecto.create && \
    mix ecto.migrate

CMD ["mix", "run", "--no-halt"]
EXPOSE 4000
