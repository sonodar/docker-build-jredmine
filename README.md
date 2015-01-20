# docker-build-jredmine

Docker image: debian wheezy, oracle-jdk8, jruby, for redmine.war build.

## Example

```shell
# Set container directory path
ADDITIONAL_PLUGIN_DIR=/opt/redmine/additional_plugins
ADDITIONAL_THEME_DIR=/opt/redmine/additional_themes
BUILD_DIR=/build

sudo docker run -it --rm \
  -e ADDITIONAL_PLUGIN_DIR=$ADDITIONAL_PLUGIN_DIR \
  -e ADDITIONAL_THEME_DIR=$ADDITIONAL_THEME_DIR \
  -e BUILD_DIR=$BUILD_DIR \
  -e REDMINE_LANG=ja \
  -v `pwd`/plugins:$ADDITIONAL_PLUGIN_DIR \
  -v `pwd`/themes:$ADDITIONAL_THEME_DIR \
  -v `pwd`/build:$BUILD_DIR \
  -v `pwd`/warble.rb:/var/lib/redmine/config/warble.rb \
  sonodar/build-jredmine
```

