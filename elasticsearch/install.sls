# Install elasticsearch
{%- set version = salt['pillar.get']('elasticsearch:version') %}

elasticsearch:
  pkg.installed:
{%- if version is defined %}
    - version: {{ version }}
    - hold: True # prevent automatic upgrades
{%- endif %}
    - require:
      - pkg: default-jre-headless
