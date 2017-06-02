# Install Elasticsearch repository

{%- set version = salt['pillar.get']('elasticsearch:version') %}
{%- set repo_version = salt['pillar.get']('elasticsearch:repo_version', '1.1') %}
{% if salt['pkg.version_cmp'](version, '5.0.0') >= 0 %}
  {%- set repo_definition = 'deb http://artifacts.elastic.co/packages/' ~ repo_version ~ '/apt stable main' %}
  {%- set file = 'elastic' %}
{% else %}
  {%- set repo_definition = 'deb http://packages.elastic.co/elasticsearch/' ~ repo_version ~ '/debian stable main'%}
  {%- set file = 'elasticsearch' %}
{% endif %}

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: Elasticsearch Repo
    - name: {{ repo_definition }}
    - file: {{ '/etc/apt/sources.list.d/' ~ file ~ '.list' }}
    - keyid: D88E42B4
    - keyserver: keyserver.ubuntu.com
    - require_in:
      - pkg: elasticsearch
