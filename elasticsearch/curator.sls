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

{%- set version = salt['pillar.get']('elasticsearch:version') %}
{% if salt['pkg.version_cmp'](version, '5.0.0') >= 0 %}
  {%- set curator_command = 'curator_cli' %}
  {%- set curator_delete_indices = 'delete_indices' %}

  {%- set json_filter = [
    {
      'filtertype': "age",
      'source': "creation_date",
      'direction': "older",
      'unit': "{{ time_unit }}",
      'unit_count': "{{ older_than }}"
    },
    {
      'filtertype': "pattern",
      'kind': "prefix",
      'value': "{{ index }}"
    }
  ]
  %}
  {%- set curator_filter = "--filter_list {{ json_filter | json }}" %}
{% else %}
  {%- set curator_command = 'curator' %}
  {%- set curator_delete_indices = 'delete indices' %}
  {%- set curator_filter = '--prefix "{{ index }}-" --older-than {{ older_than }} --time-unit {{ time_unit }} --timestring {{ timestring|replace("%", "\%") }}' %}
{% endif %}

/usr/local/bin/{{ curator_command }} {{ curator_delete_indices }} {{ curator_filter }}:
  cron.present:
    - identifier: Auto-cleaning old ES data for {{ index }}
    - user: root
    - hour: 3
    - minute: 0
{%- endfor %}
