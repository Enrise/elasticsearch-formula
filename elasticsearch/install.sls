# Install elasticsearch
{%- set version = salt['pillar.get']('elasticsearch:version') %}

elasticsearch:
  pkg:
    - installed
{%- if version is defined %}
    - version: {{ version }}
{%- endif %}
{% if salt['grains.get']('os_family') != 'Debian' %}
    - require:
      - pkg: default-jre-headless
{%- endif %}
