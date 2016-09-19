{%- from "hadoop/settings.sls" import hadoop with context %}
{%- from "hadoop/spark/settings.sls" import spark with context %}
{%- from 'hadoop/user_macro.sls' import hadoop_user with context %}
{%- from 'hadoop/hdfs/settings.sls' import hdfs with context %}

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

spark-home-link-update:
  alternatives.set:
    - name: spark-home-link
    - path: {{ spark['real_home'] }}

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
      - alternatives: spark-home-link-update

#create directory for logging
{{ spark['real_home'] }}/logs:
  file.directory:
    - user: spark
    - mode: 755
    - require:
      - alternatives: spark-home-link-update

#create directory for logging applications
{{ spark['real_home'] }}/work:
  file.directory:
    - user: spark
    - mode: 755
    - require:
      - alternatives: spark-home-link-update

/etc/spark:
  file.directory:
    - user: root
    - group: root
    - mode: 755

{%- set real_config_src=spark['real_home']+'/conf' %}

move-spark-dist-conf:
  file.directory:
    - name: {{ spark['real_config'] }}
    - user: root
    - grou: root
  cmd.run:
    - name: mv {{ real_config_src }} {{ spark.real_config_dist }}
    - unless: test -d {{ spark.real_config_dist }}
    - onlyif: test -d {{ real_config_src }}
    - require: 
      - file: /etc/spark

{{ real_config_src }}:
  file.symlink:
    - target: {{ spark['alt_config'] }}
    - force: true
    - require:
      - cmd: move-spark-dist-conf

spark-conf-link:
  alternatives.install:
    - link: {{ spark['alt_config'] }}
    - path: {{ spark['real_config'] }}
    - priority: 30
    - require:
      - file: {{ spark['real_config'] }}

{{ spark['real_config'] }}/spark-env.sh:
  file.managed:
    - source: salt://hadoop/conf/spark/spark-env.sh
    - template: jinja
    - mode: 644
    - user: root
    - group: root
    - context:
      java_home: {{ hadoop.java_home }}
      hadoop_conf_dir: {{ hadoop.alt_config }}

{%- for file in spark['conf_files'] %}
{{ spark['real_config'] }}/{{ file }}:
  file.copy:
    - source: {{ spark['real_config_dist'] }}/{{ file }}
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: {{ spark['real_config'] }}
      - alternatives: spark-conf-link
      - cmd: move-spark-dist-conf
{%- endfor %}

{{ spark.alt_config }}/slaves:
  file.managed:
    - mode: 644
    - contents: |
{%- for slave in hdfs.datanode_hosts %}
        {{ slave }}
{%- endfor %}

{% if spark.is_sparkmaster %}
#start spark daemons
{{ spark['real_home'] }}/sbin/start-all.sh:
  cmd.run:
  - user: spark
  - shell: /bin/bash
  - require:
    - alternatives: spark-home-link-update
{% endif %}

{% if spark.is_sparkslave %}
{% endif %}

{% endif %}
