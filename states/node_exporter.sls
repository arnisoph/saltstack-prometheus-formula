#!jinja|yaml

{% set datamap = salt['formhelper.defaults']('prometheus', saltenv) %}

# SLS includes/ excludes
include: {{ datamap.sls_include|default(['._user']) }}
extend: {{ datamap.sls_extend|default({}) }}


{% for v_id, version in datamap.node_exporter.versions|default({})|dictsort %}
prometheus_node_exporter_version_{{ v_id }}:
  archive:
    - extracted
    - name: /srv/prometheus-node_exporter/{{ v_id }}
    - source: {{ version.source }}
    - source_hash: {{ version.source_hash }}
    - user: prometheus
    - group: prometheus
    - keep: True
    - archive_format: {{ version.archive_format|default('tar') }}
{% endfor %}

prometheus_node_exporter_link_current_version:
  file:
    - symlink
    - name: /srv/prometheus-node_exporter/current
    - target: /srv/prometheus-node_exporter/{{ datamap.node_exporter.cur_version }}/
    - user: prometheus
    - group: prometheus

{% if salt['grains.get']('init') == 'systemd' %}
prometheus_node_exporter_service_script:
  file:
    - managed
    - name: /etc/systemd/system/prometheus-node_exporter.service
    - user: root
    - group: root
    - contents: |
        [Unit]
        Description=prometheus
        After=syslog.target network.target

        [Service]
        Type=simple
        RemainAfterExit=no
        WorkingDirectory=/srv/prometheus-node_exporter/current
        User=prometheus
        Group=prometheus
        ExecStart=/srv/prometheus-node_exporter/current/node_exporter -log.level info

        [Install]
        WantedBy=multi-user.target
{% endif %}

prometheus_node_exporter_service:
  service:
    - running
    - name: prometheus-node_exporter
    - enable: True
