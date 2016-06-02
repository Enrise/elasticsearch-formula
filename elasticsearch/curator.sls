{%- set indices = salt['pillar.get']('elasticsearch:indices', {}) %}

elasticsearch-curator-pip:
  pkg.installed:
    - name: python-pip

elasticsearch-curator:
  pip.installed:
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
