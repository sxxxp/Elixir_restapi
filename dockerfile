# 1단계: Build Stage
FROM hexpm/elixir:1.18.3-erlang-25.3.2.21-alpine-3.19.7 AS builder

WORKDIR /app

COPY mix.exs mix.lock ./
COPY config ./config
COPY lib ./lib
COPY priv ./priv
COPY logs ./logs
ENV MIX_ENV=prod

RUN mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get --only prod && \
    mix deps.compile && \
    mix release

# 2단계: Runtime Stage
FROM alpine:3.19.7 AS runtime

# 앱 실행에 필요한 최소 패키지
RUN apk add --no-cache openssl ncurses-libs libstdc++

# 작업 디렉토리 설정
WORKDIR /app

# 릴리즈된 파일만 복사
COPY --from=builder /app/_build/prod/rel/restapi ./

# 기본 포트 설정 (선택)
ENV port=4000

# 실행 명령
ENTRYPOINT ["bin/restapi"]
CMD ["start"]
