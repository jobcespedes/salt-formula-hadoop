{%- from "hadoop/settings.sls" import hadoop with context %}
{%- from "hadoop/spark/settings.sls" import spark with context %}
{%- from 'hadoop/user_macro.sls' import hadoop_user with context %}

{% if spark.is_sparktarget %}
{%- set hadoop_users = hadoop.get('users', {}) %}
{%- set username = 'spark' %}
{%- set uid = hadoop_users.get(username, '6004') %}

{{ hadoop_user(username, uid) }}

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

/etc/profile.d/spark.sh:
  file.managed:
    - source: salt://hadoop/files/spark.sh.jinja
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      alt_home: {{ spark['alt_home'] }}
    - require:
      - alternatives: spark-home-link

#create directory for logging
{{ spark['real_home'] }}/logs:
  file.directory:
    - user: spark
    - mode: 755
    - require:
      - alternatives: spark-home-link

{% if spark.is_sparkmaster %}
#start spark daemons
{{ spark['real_home'] }}/sbin/start-all.sh:
  cmd.run:
  - user: spark
  - shell: /bin/bash
  - require:
    - alternatives: spark-home-link
{% endif %}

{% if spark.is_sparkslave %}
{% endif %}

{% endif %}
