FROM rust:1.80.1 AS builder
WORKDIR /build
RUN git clone --branch master https://github.com/a-givertzman/api-server.git api-server
RUN cd ./api-server && cargo build --release

FROM debian:12.6-slim AS runner
WORKDIR /app
COPY --from=builder /build/api-server/target/release/api-server ./
COPY --from=builder /build/api-server/extensions/ ./extensions/
COPY config.yaml ./config.yaml
CMD ./api-server