{%- from "hadoop/settings.sls" import hadoop with context %}
{%- from "hadoop/spark/settings.sls" import spark with context %}

{% if spark.is_sparktarget %}
unpack-spark-package:
  cmd.run:
    - name: curl '{{ spark.source_url }}' | tar xz --no-same-owner
    - cwd: /usr/lib
    - unless: test -d {{ spark['real_home'] }}/lib

spark-home-link:
  alternatives.install:
    - link: {{ spark['alt_home'] }}
    - path: {{ spark['real_home'] }}
    - priority: 30
    - require:
      - cmd: unpack-spark-package
{% endif %}
