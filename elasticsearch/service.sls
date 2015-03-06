# Install ES package as a service
extend:
  elasticsearch:
    service.running:
      - enable: True
      - reload: True
      - watch:
        - pkg: elasticsearch
      - require:
        - pkg: elasticsearch
