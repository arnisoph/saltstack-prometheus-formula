prometheus:
  lookup:
    server:
      cur_version: 0.16.1
      versions:
        '0.16.1':
          # cd /vagrant/shared/misc && wget https://github.com/prometheus/prometheus/releases/download/0.16.1/prometheus-0.16.1.linux-amd64.tar.gz
          source: salt://misc/prometheus-0.16.1.linux-amd64.tar.gz
          source_hash: md5=ae89dcc61ad6b52caa4f9b652bebce36
          config:
            global:
              scrape_interval:     15s # By default, scrape targets every 15 seconds.
              evaluation_interval: 15s # By default, scrape targets every 15 seconds.
              # scrape_timeout is set to the global default (10s).

              # Attach these labels to any time series or alerts when communicating with
              # external systems (federation, remote storage, Alertmanager).
              external_labels:
                monitor: 'codelab-monitor'

            # A scrape configuration containing exactly one endpoint to scrape:
            # Here it's Prometheus itself.
            scrape_configs:
              # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
              - job_name: 'prometheus'

                # Override the global default and scrape targets from this job every 5 seconds.
                scrape_interval: 5s
                scrape_timeout: 10s

                target_groups:
                  - targets: ['localhost:9090']
    node_exporter:
      cur_version: 0.12.0rc1
      versions:
        '0.12.0rc1':
          # cd /vagrant/shared/misc && wget https://github.com/prometheus/node_exporter/releases/download/0.12.0rc1/node_exporter-0.12.0rc1.linux-amd64.tar.gz
          source: salt://misc/node_exporter-0.12.0rc1.linux-amd64.tar.gz
          source_hash: md5=43d253ea664ea446c6c4a42e03400b30

