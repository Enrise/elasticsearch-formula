# Library with macro's
{%- macro elasticsearch_plugin(name, plugin_dir, package) %}
{%- set es_plugin_path = salt['pillar.get']('elasticsearch:plugin_path', '/usr/share/elasticsearch/bin/plugin') %}
# Installs {{ name }} plugin for ElasticSearch
es_plugin_{{ name }}:
  cmd.run:
    - name: {{ es_plugin_path }} install {{ package }}
    - creates: /usr/share/elasticsearch/plugins/{{ plugin_dir }}
{%- endmacro %}
