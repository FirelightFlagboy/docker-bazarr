# syntax=docker/dockerfile:1.4

FROM --platform=$BUILDPLATFORM alpine:3.20 as builder

COPY --link pkg-info.json /pkg-info.json

ARG PKG_VERSION
ARG TARGETARCH

COPY --link in-docker-build.sh /build.sh

RUN sh /build.sh

FROM alpine:3.20

ARG PKG_VERSION

LABEL org.opencontainers.image.source="https://github.com/morpheus65535/bazarr"
LABEL org.opencontainers.image.description="Bazarr is a companion application to Sonarr and Radarr. It manages and downloads subtitles based on your requirements. You define your preferences by TV show or movie and Bazarr takes care of everything for you."
LABEL org.opencontainers.image.version=${PKG_VERSION}
LABEL org.opencontainers.image.title="Bazarr"

COPY --from=builder /opt/bazarr /opt/bazarr
RUN apk --no-cache add \
    python3 ffmpeg 7zip \
    yq curl

COPY ./healthcheck.sh /healthcheck.sh

USER 1234:1234
ENV CONFIG_DIR=/config
ENV PORT=6767
ENV VIRTUAL_ENV=/opt/bazarr/.venv
ENV PYTHONPATH=${VIRTUAL_ENV}
ENV PYTHON_EXEC=${VIRTUAL_ENV}/bin/python3

ENTRYPOINT ${VIRTUAL_ENV}/bin/python3 "/opt/bazarr/bazarr.py" "--port" $PORT "--config" $CONFIG_DIR "--no-update=true"

HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 CMD ash /healthcheck.sh
