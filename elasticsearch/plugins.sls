# Install the ES plugins
{% from "elasticsearch/lib.sls" import elasticsearch_plugin %}
{%- set es_plugins = salt['pillar.get']('elasticsearch:plugins', {}) %}

# Install the configured ES plugins
{%- for plugin, data in es_plugins.items()  %}
{{ elasticsearch_plugin(plugin, data.plugin_dir, data.package) }}
{%- endfor -%}
