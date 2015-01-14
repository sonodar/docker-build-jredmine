#!/bin/bash

ADDITIONAL_PLUGIN_DIR=${ADDITIONAL_PLUGIN_DIR:=${REDMINE_ROOT}/additional_plugins}
ADDITIONAL_THEME_DIR=${ADDITIONAL_THEME_DIR:=$REDMINE_ROOT/additional_themes}
BUILD_DIR=${BUILD_DIR:=/build}

cd ${REDMINE_ROOT}

/etc/init.d/mysql start
echo -n "Wait 5 seconds, for mysql-server fully startup ... "
sleep 5 && echo "Done."

if [[ -d ${ADDITIONAL_PLUGIN_DIR} ]]; then
  if [[ $(ls -U1 ${ADDITIONAL_PLUGIN_DIR} | grep -v README | wc -l) != "0" ]]; then
    echo -n "Coping additional plugins ... "
    cp -r ${ADDITIONAL_PLUGIN_DIR}/* ${REDMINE_ROOT}/plugins/ > /dev/null
    [ $? -ne 0 ] && (echo "Error!"; exit 1)
    echo "Done."
    echo "Execute bundle update."
    jruby -S bundle update
  fi
fi

if [[ -d ${ADDITIONAL_THEME_DIR} ]]; then
  if [[ $(ls -U1 ${ADDITIONAL_THEME_DIR} | grep -v README | wc -l) != "0" ]]; then
    echo -n "Coping additional themes ... "
    cp -r ${ADDITIONAL_THEME_DIR}/* ${REDMINE_ROOT}/public/themes/ > /dev/null
    [ $? -ne 0 ] && (echo "Error!"; exit 1)
    echo "Done."
  fi
fi

echo "Execute database migration, and load default data for japanese."
jruby -S bundle exec rake db:migrate --trace
jruby -S bundle exec rake redmine:load_default_data REDMINE_LANG=${REDMINE_LANG:=ja} --trace

echo "Execute mysqldump for redmine database."
mysqldump -uredmine -predmine redmine > redmine.dmp

echo "Making redmine.war"
jruby -S bundle exec warble

echo "Coping built files."
cp redmine.war redmine.dmp ${BUILD_DIR}/

exit $?

