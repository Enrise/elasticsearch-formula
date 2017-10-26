# Install ES package as a service
extend:
  elasticsearch:
    service.running:
      - enable: True
      - init_delay: 5
      - watch:
        - pkg: elasticsearch
      - require:
        - pkg: elasticsearch
