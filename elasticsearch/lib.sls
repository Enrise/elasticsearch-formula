# Library with macro's
{%- macro elasticsearch_plugin(name, plugin_dir, package) %}
# Installs {{ name }} plugin for ElasticSearch
es_plugin_{{ name }}:
  cmd.run:
    - name: /usr/share/elasticsearch/bin/plugin install {{ package }}
    - creates: /usr/share/elasticsearch/plugins/{{ plugin_dir }}
{%- endmacro %}
