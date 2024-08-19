FROM        quay.io/prometheus/busybox:latest
LABEL       Sophos <hnlq.sysu@gmail.com>

COPY ./dist/lbx-exporter_linux_amd64_v1/lbx-exporter  /bin/lbs-exporter
COPY docker-entrypoint.sh /bin/docker-entrypoint.sh

ENV LBS_HOST "http://localhost"
ENV METRICS_ENDPOINT "/metrics"
ENV METRICS_ADDR ":9913"
ENV DEFAULT_METRICS_NS "lbs"

ENTRYPOINT [ "docker-entrypoint.sh" ]