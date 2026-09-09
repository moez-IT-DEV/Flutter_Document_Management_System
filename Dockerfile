
ARG FLUTTER_VERSION=3.29.0
FROM ghcr.io/cirruslabs/flutter:${FLUTTER_VERSION} AS builder

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get


COPY . .


RUN flutter build web --release


FROM nginx:stable-alpine

LABEL maintainer="Moez Kchaou <moez.kchaoumail@gmail.com>"
LABEL description="Flutter Web DMS Application"
LABEL version="1.0.0"


COPY --from=builder /app/build/web /usr/share/nginx/html


COPY nginx.conf /etc/nginx/conf.d/default.conf


RUN addgroup -S appgroup && adduser -S appuser -G appgroup \
    && chown -R appuser:appgroup /usr/share/nginx/html \
    && chown -R appuser:appgroup /var/cache/nginx \
    && chown -R appuser:appgroup /var/log/nginx \
    && touch /var/run/nginx.pid \
    && chown -R appuser:appgroup /var/run/nginx.pid

USER appuser


HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
