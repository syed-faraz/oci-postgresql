#!/bin/bash

# Disable local firewall
service firewalld stop
chkconfig firewalld off

# Install the repository RPM
yum install -y https://download.postgresql.org/pub/repos/yum/11/redhat/rhel-7-x86_64/pgdg-oraclelinux11-11-2.noarch.rpm

# Install the client packages
yum install -y postgresql11

# Install the server packages
yum install -y postgresql11-server

# Initialize the database and enable automatic start
/usr/pgsql-11/bin/postgresql-11-setup initdb
systemctl enable postgresql-11
systemctl start postgresql-11

# Change password of postgres user
echo "postgres:${password}" | chpasswd

# Change the DB password
sudo -u postgres bash -c "supsql -d template1 -c "ALTER USER postgres WITH PASSWORD '${password}';""