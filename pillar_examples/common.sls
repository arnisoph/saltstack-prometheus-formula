prometheus:
  lookup:
    server:
      cur_version: 0.16.1
      versions:
        '0.16.1':
          #source: https://github.com/prometheus/prometheus/releases/download/0.16.1/prometheus-0.16.1.linux-amd64.tar.gz
          source: 'https://github-cloud.s3.amazonaws.com/releases/6838921/55ac9496-7409-11e5-8143-fba613f5eb4c.gz?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Credential=AKIAISTNZFOVBIJMK3TQ%2F20151206%2Fus-east-1%2Fs3%2Faws4_request&X-Amz-Date=20151206T194839Z&X-Amz-Expires=300&X-Amz-Signature=9b2d0cb9f965876c001d5e2b10182dd1d02242af07b2c7aa59930e73347fe55d&X-Amz-SignedHeaders=host&actor_id=0&response-content-disposition=attachment%3B%20filename%3Dprometheus-0.16.1.linux-amd64.tar.gz&response-content-type=application%2Foctet-stream'
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
