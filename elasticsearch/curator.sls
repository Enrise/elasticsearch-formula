{%- set indices = salt['pillar.get']('elasticsearch:indices', {}) %}
{%- set curator_version = salt['pillar.get']('elasticsearch:curator:version') %}
{%- set curator_pkg_string = 'elasticsearch-curator' %}
{%- if curator_version is defined %}
{%- set curator_pkg_string = curator_pkg_string ~ ' ' ~ curator_version %}
{%- endif %}

elasticsearch-curator-pip:
  pkg.installed:
    - name: python-pip

elasticsearch-curator:
  pip.installed:
    - name: {{ curator_pkg_string }}
    - require:
      - pkg: python-pip

{%- for index, data in indices.items() %}
{%- set older_than = data.get('curator-older-than', '30') %}
{%- set time_unit = data.get('curator-time-unit', 'days') %}
{%- set timestring = data.get('curator-timestring', '%Y.%m.%d') %}

/usr/local/bin/curator delete indices --prefix "{{ index }}-" --older-than {{ older_than }} --time-unit {{ time_unit }} --timestring {{ timestring|replace('%', '\%') }}:
  cron.present:
    - identifier: Auto-cleaning old ES data for {{ index }}
    - user: root
    - hour: 3
    - minute: 0
{%- endfor %}
