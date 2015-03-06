# Library with macro's
{%- macro elasticsearch_plugin(name, module_dir, url='') %}
# Installs {{ name }} plugin for ElasticSearch
es_plugin_{{ module_dir }}:
  cmd.run:
    {%- if url != '' %}
    - name: /usr/share/elasticsearch/bin/plugin -install "{{ name }}" -url "{{ url }}"
    {%- else %}
    - name: /usr/share/elasticsearch/bin/plugin -install "{{ name }}"
    {%- endif %}
    - creates: /usr/share/elasticsearch/plugins/{{ module_dir }}
    #- unless: "test /usr/share/elasticsearch/bin/plugin -l | grep {{ module_dir }}$"
{%- endmacro %}
