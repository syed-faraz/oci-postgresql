#!/bin/bash

export pg_version='${pg_version}'

# Optionally initialize the database and enable automatic start:
if [[ $pg_version == "9.6" ]]; then 
	sudo /usr/pgsql-${pg_version}/bin/postgresql${pg_version_no_dot}-setup initdb
else
	sudo /usr/pgsql-${pg_version}/bin/postgresql-${pg_version_no_dot}-setup initdb
fi	
sudo systemctl enable postgresql-${pg_version}
sudo systemctl start postgresql-${pg_version}
sudo systemctl status postgresql-${pg_version}

if [[ $pg_version == "9.6" ]]; then 
	sudo -u root bash -c "tail -5 /var/lib/pgsql/${pg_version}/data/pg_log/postgresql-*.log"
else
	sudo -u root bash -c "tail -5 /var/lib/pgsql/${pg_version}/data/log/postgresql-*.log"
fi
