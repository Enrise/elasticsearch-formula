# Install Elasticsearch repository
{%- set repo_version = salt['pillar.get']('elasticsearch:repo_version', '1.1') %}
{%- set repo_definition = salt['pillar.get']('elasticsearch:repo_definition', 'deb http://packages.elastic.co/elasticsearch/' ~ repo_version ~ '/debian stable main') %}

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch Repo
    - name: {{ repo_definition }}
    - file: /etc/apt/sources.list.d/elasticsearch.list
    - keyid: D88E42B4
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: elasticsearch
