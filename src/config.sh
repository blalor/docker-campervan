#!/bin/bash

set -e -x -u

cd /tmp/src

# groupadd -g 600 campervan
# useradd -g campervan -u 600 -r campervan

mv program-camper_van.conf /etc/supervisor.d/
mv logstash-forwarder-camper_van.json /etc/logstash-forwarder.d/camper_van.json

# yum install -y centos-release-SCL ruby193-rubygem-camper_van

## openssl-devel required for eventmachine to build with encryption support
yum install -y centos-release-SCL openssl-devel gcc-c++ git
yum install --disablerepo=* --enablerepo=scl -y ruby193-ruby-devel ruby193-rubygem-json ruby193-rubygem-bundler

## gotta be a better way
export LD_LIBRARY_PATH="$( scl enable ruby193 'echo ${LD_LIBRARY_PATH}' )"
export PATH="$( scl enable ruby193 'echo ${PATH}' )"
export PKG_CONFIG_PATH="$( scl enable ruby193 'echo ${PKG_CONFIG_PATH}' )"

git clone https://github.com/icco/camper_van.git /src/camper_van

cd /src/camper_van
rm -f .ruby-{gemset,version}
sed -i "3i gem 'firering', :github => 'icco/firering', :branch => 'fix_logging_bug'" Gemfile
bundle install

## cleanup
cd /
yum clean all
rm -rf /var/tmp/yum-root* /tmp/src
