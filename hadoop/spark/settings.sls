{% set p  = salt['pillar.get']('spark', {}) %}
{% set pc = p.get('config', {}) %}
{% set g = salt['grains.get']('spark', {}) %}
{% set gc = g.get('config', {}) %}

{%- set versions = {} %}
{%- set default_dist_id = 'spark-1.5.1-bin-hadoop2.6' %}
{%- set dist_id = g.get('version', p.get('version', default_dist_id)) %}

# Several prebuilt versions for different versions of hadoop
{%- set default_versions = { 'spark-1.5.1-bin-hadoop2.6' : { 'version'       : '1.5.1-bin-hadoop2.6',
                                                             'version_name'  : 'spark-1.5.1-bin-hadoop2.6',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.5.1-bin-hadoop2.6.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.5.0-bin-hadoop2.6'  : { 'version'       : '1.5.0-bin-hadoop2.6',
                                                             'version_name'  : 'spark-1.5.0-bin-hadoop2.6',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.6.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.4.1-bin-hadoop2.6'  : { 'version'       : '1.4.1-bin-hadoop2.6',
                                                             'version_name'  : 'spark-1.4.1-bin-hadoop2.6',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop2.6.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.4.0-bin-hadoop2.6'  : { 'version'       : '1.4.0-bin-hadoop2.6',
                                                             'version_name'  : 'spark-1.4.0-bin-hadoop2.6',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0-bin-hadoop2.6.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.3.1-bin-hadoop2.6'  : { 'version'       : '1.3.1-bin-hadoop2.6',
                                                             'version_name'  : 'spark-1.3.1-bin-hadoop2.6',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.6.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.5.1-bin-hadoop2.4' : { 'version'       : '1.5.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.5.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.5.1-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.5.0-bin-hadoop2.4' : { 'version'       : '1.5.0-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.5.0-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.5.0-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                            'spark-1.4.1-bin-hadoop2.4' : { 'version'       : '1.4.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.4.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.4.1-bin-hadoop2.4.tgz')),    
                                                             'major_version' : '1'
                                                            },
                             'spark-1.4.0-bin-hadoop2.4' : { 'version'       : '1.4.0-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.4.0-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.4.0-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.3.1-bin-hadoop2.4' : { 'version'       : '1.3.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.3.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.3.1-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.3.0-bin-hadoop2.4' : { 'version'       : '1.3.0-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.3.0-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.3.0-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.2.2-bin-hadoop2.4' : { 'version'       : '1.2.2-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.2.2-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.2.2-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.2.1-bin-hadoop2.4' : { 'version'       : '1.2.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.2.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.2.1-bin-hadoop2.4' : { 'version'       : '1.2.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.2.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.2.1-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.2.0-bin-hadoop2.4' : { 'version'       : '1.2.0-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.2.0-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.2.0-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },
                             'spark-1.1.1-bin-hadoop2.4' : { 'version'       : '1.1.1-bin-hadoop2.4',
                                                             'version_name'  : 'spark-1.1.1-bin-hadoop2.4',
                                                             'source_url'    : g.get('source_url', p.get('source_url', 'http://d3kbcqa49mib13.cloudfront.net/spark-1.1.1-bin-hadoop2.4.tgz')),
                                                             'major_version' : '1'
                                                            },

                           }%}

{%- set versions         = p.get('versions', default_versions) %}
{%- set version_info     = versions.get(dist_id, versions['spark-1.5.1-bin-hadoop2.6']) %}
{%- set alt_home         = salt['pillar.get']('spark:prefix', '/usr/lib/spark') %}
{%- set real_home        = '/usr/lib/' + version_info['version_name'] %}
# only install spark on what is specified as the spark target. Defaults to the hadoop_master
{%- set spark_target      = g.get('spark_target', p.get('spark_target', 'roles:hadoop_master')) %}
{%- set targeting_method            = salt['grains.get']('hadoop:targeting_method', salt['pillar.get']('hadoop:targeting_method', 'grain')) %}

{%- set is_sparktarget = salt['match.' ~ targeting_method](spark_target) %}

{%- set spark = {} %}
{%- do spark.update({  'dist_id'          : dist_id,
                       'version'          : version_info['version'],
                       'source_url'       : version_info['source_url'],
                       'major_version'    : version_info['major_version']|string(),
                       'alt_home'         : alt_home,
                       'real_home'        : real_home,
                       'is_sparktarget'   : is_sparktarget,
                   }) %}
