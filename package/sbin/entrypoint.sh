#!/usr/bin/env bash
source scl_source enable rh-python36

cd /opt/syslog-ng
for d in $(find /opt/syslog-ng/etc -type d)
do
  echo Templating conf for $d
  gomplate \
    --input-dir=$d \
    --template t=etc/go_templates/  \
    --exclude=*.conf --exclude=*.csv --exclude=*.t --exclude=.*\
    --output-map="$d/{{ .in | strings.ReplaceAll \".conf.tmpl\" \".conf\" }}"
done

cp -n /opt/syslog-ng/etc/context_templates/* /opt/syslog-ng/etc/conf.d/local/context

echo syslog-ng starting
exec /opt/syslog-ng/sbin/syslog-ng $@