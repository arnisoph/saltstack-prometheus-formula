#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('prometheus', saltenv) %}

# SLS includes/ excludes
include: {{ datamap.sls_include|default([]) }}
extend: {{ datamap.sls_extend|default({}) }}


group_prometheus:
  group:
    - present
    - name: prometheus
    - system: True

user_prometheus:
  user:
    - present
    - name: prometheus
    - groups:
      - prometheus
    - home: /srv/prometheus
    - createhome: True
    - shell: /bin/bash
    - system: True

{% for v_id, version in datamap.server.versions|default({})|dictsort %}
prometheus_server_version_{{ v_id }}:
  archive:
    - extracted
    - name: /srv/prometheus/{{ v_id }}
    - source: {{ version.source }}
    - source_hash: {{ version.source_hash }}
    - user: prometheus
    - group: prometheus
    - keep: True
    - archive_format: {{ version.archive_format|default('tar') }}

prometheus_server_{{ v_id }}_config:
  file:
    - serialize
    - name: /srv/prometheus/{{ v_id }}/prometheus-{{ datamap.server.cur_version }}.linux-amd64/prometheus.yaml
    - user: prometheus
    - group: prometheus
    - mode: 640
    - dataset_pillar: prometheus:lookup:server:versions:{{ v_id }}:config
    - watch_in:
      - service: prometheus
{% endfor %}

prometheus_server_link_current_version:
  file:
    - symlink
    - name: /srv/prometheus/current
    - target: /srv/prometheus/{{ datamap.server.cur_version }}/prometheus-{{ datamap.server.cur_version }}.linux-amd64
    - user: prometheus
    - group: prometheus

{% if salt['grains.get']('init') == 'systemd' %}
prometheus_server_service_script:
  file:
    - managed
    - name: /etc/systemd/system/prometheus.service
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=prometheus
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory=/srv/prometheus/current
        User=prometheus
        Group=prometheus
        ExecStart=/srv/prometheus/current/prometheus -config.file=/srv/prometheus/current/prometheus.yaml -log.level info

        [Install]
        WantedBy=multi-user.target
{% endif %}

prometheus_server_service:
  service:
    - running
    - name: prometheus
    - enable: True
