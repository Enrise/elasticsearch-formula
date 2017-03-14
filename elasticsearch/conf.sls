# Config ES
{%- set config = salt['pillar.get']('elasticsearch:config') %}
{%- set default_conf = salt['pillar.get']('elasticsearch:init_defaults') %}
{%- set jvm_options = salt['pillar.get']('elasticsearch:jvm_options') %}
{%- set es_config_template = salt['pillar.get']('elasticsearch:template', 'salt://elasticsearch/templates/elasticsearch.yml.jinja') %}
{%- set es_config_template_type = salt['pillar.get']('elasticsearch:template_type', 'jinja') %}

# Install ElasticSearch config
/etc/elasticsearch/elasticsearch.yml:
  file.managed:
    - source: {{ es_config_template }}
    - template: {{ es_config_template_type }}
    {%- if config is mapping %}
    {%- for key, value in config.items() %}
    - {{ key }}: {{ value|json() }}
    {%- endfor %}
    {%- endif %}
    - watch_in:
      - service: elasticsearch
    - require_in:
      - service: elasticsearch

# Configure init config
{%- if default_conf is mapping %}
/etc/default/elasticsearch:
  file.append:
    - text:
      {%- for key, value in default_conf.iteritems() %}
      - "{{ key|upper }}={{ value }}"
      {%- endfor %}
    - watch_in:
      - service: elasticsearch
    - require_in:
      - service: elasticsearch
{%- endif %}

# Configure jvm.options
{%- if jvm_options is defined %}
jvm_options:
  file.blockreplace:
    - name: /etc/elasticsearch/jvm.options
    - marker_start: "# START managed zone jvm_options -DO-NOT-EDIT-"
    - marker_end: "# END managed zone jvm_options --"
    - content: |
      {%- for value in jvm_options %}
        {{ value }}
      {%- endfor %}
    - backup: false
    - append_if_not_found: True
    - show_changes: True
{%- endif %}
