# Config ES
{%- set config = salt['pillar.get']('elasticsearch:config') %}
{%- set default_conf = salt['pillar.get']('elasticsearch:init_defaults') %}
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
