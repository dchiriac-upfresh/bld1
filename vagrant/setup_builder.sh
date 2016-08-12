#!/bin/bash

echo "Provisioning"

yum -y install rpm-build apr-devel java-1.8.0-openjdk-devel

rbenv install 2.3.1
rbenv global 2.3.1 
gem install fpm

gpg --allow-secret-key-import --import /vagrant/vagrant/gpg_keys/SECRET-RPM-GPG-KEY-upfresh
gpg --import gpg --import /vagrant/vagrant/gpg_keys/RPM-GPG-KEY-upfresh
cp /vagrant/.rpmmacros /root/.rpmmacros