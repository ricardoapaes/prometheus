FROM prom/prometheus:latest
COPY prometheus.yml /etc/prometheus/prometheus.yml
ARG HOST_EXPORTERS
RUN sed -i "s/{{hostExporters}}/${HOST_EXPORTERS}/g" /etc/prometheus/prometheus.yml