FROM sonodar/jruby:latest

MAINTAINER sonodar <ryoheisonoda@outlook.com>

# Update packages
RUN apt-get update && apt-get upgrade -y

# Install git, imagemagick, mysql-server
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install \
    git imagemagick libmagickcore-dev libmagickwand-dev mysql-server-5.5

# Set constants
ENV REDMINE_VERSION 2.6

# Set environment variables
ENV REDMINE_ROOT /opt/redmine
ENV RAILS_ENV production

# Clone redmine repository
RUN git clone -b $REDMINE_VERSION-stable https://github.com/redmine/redmine.git ${REDMINE_ROOT}

WORKDIR ${REDMINE_ROOT}

# Add gems
RUN echo 'gem "warbler"' >> Gemfile
RUN echo 'gem "rmagick4j"' >> Gemfile

# Add database.yml (see. database.yml)
ADD database.yml ${REDMINE_ROOT}/config/database.yml

# Install bundles
RUN jruby -S bundle install --without development test --path vendor/bundle

# Create database for migration
RUN /etc/init.d/mysql start && sleep 10 \
    && echo "CREATE DATABASE redmine DEFAULT CHARACTER SET utf8;" | mysql -uroot \
    && echo "GRANT ALL ON redmine.* to redmine@localhost identified by 'redmine';" | mysql -uroot \
    && echo "FLUSH PRIVILEGES" | mysql -uroot

# Add build script (see. jredmine-build.sh)
ADD build-jredmine.sh /build-jredmine.sh
CMD ["/bin/bash", "/build-jredmine.sh"]

# Add warble.rb (see. warble.rb)
ADD warble.rb ${REDMINE_ROOT}/config/warble.rb

# Clean up
RUN apt-get autoremove -y && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/*
