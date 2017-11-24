#!/bin/bash

sudo apt-get update

# Below package installations and configurations are not needed for production deployment, since an AMI with the 
# packages installed and configured will be used instead of bringing up a bare Ubuntu system

sudo apt-get install apache2 --force-yes -y
sudo apt-get install tomcat8 --force-yes -y
sudo apt-get install libtcnative-1 --force-yes -y
sudo apt-get install libapr1 --force-yes -y

#Install sample tomcat scripts for tests.This is to verify the setup.
sudo apt-get install tomcat8-examples --force-yes -y

#Install AJP connector
sudo apt-get install libapache2-mod-jk --force-yes -y

#enable AJP
sudo sed -i '/<Service name="Catalina">/a \    <Connector port="8009" protocol="AJP/1.3" redirectPort="8443" />' /etc/tomcat8/server.xml

#Add servlet test scripts, configure tomcat,apache2 & ajp connector
cd /var/lib/tomcat8/webapps
sudo mkdir pramerica
sudo mkdir -p pramerica/helloworld
sudo cp -R /usr/share/tomcat8-examples/examples/servlets/* /var/lib/tomcat8/webapps/pramerica/helloworld
sudo sed -i '/<\/VirtualHost>/i \        JkMount /pramerica* ajp13_worker' /etc/apache2/sites-enabled/000-default.conf

sudo service tomcat8 restart
sudo service apache2 restart
