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

# Change password of postgres user
echo "postgres:${pg_password}" | chpasswd

# Setting firewall rules
sudo -u root bash -c "firewall-cmd --permanent --zone=trusted --add-source=${pg_hotstandby_ip}/32"
sudo -u root bash -c "firewall-cmd --permanent --zone=trusted --add-port=5432/tcp"
sudo -u root bash -c "firewall-cmd --reload"

# Create replication user
chown postgres /tmp/postgresql_master_setup.sql
sudo -u postgres bash -c "psql -d template1 -f /tmp/postgresql_master_setup.sql"

# Update the content of postgresql.conf to support WAL
sudo -u root bash -c "echo 'wal_level = replica' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
sudo -u root bash -c "echo 'archive_mode = on' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
sudo -u root bash -c "echo 'wal_log_hints = on' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
sudo -u root bash -c "echo 'max_wal_senders = 3' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
if [[ $pg_version == "13" ]]; then 
	sudo -u root bash -c "echo 'wal_keep_size = 16MB' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
else
	sudo -u root bash -c "echo 'wal_keep_segments = 8' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
fi
sudo -u root bash -c "echo 'hot_standby = on' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
sudo -u root bash -c "echo 'listen_addresses = '\''0.0.0.0'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
sudo -u root bash -c "chown postgres /var/lib/pgsql/${pg_version}/data/postgresql.conf"

# Update the content of pg_hba to include standby host for replication
sudo -u root bash -c "echo 'host replication ${pg_replicat_username} ${pg_hotstandby_ip}/32 md5' | sudo tee -a /var/lib/pgsql/${pg_version}/data/pg_hba.conf" 
sudo -u root bash -c "echo 'host replication ${pg_replicat_username} ${pg_master_ip}/32 md5' | sudo tee -a /var/lib/pgsql/${pg_version}/data/pg_hba.conf" 
sudo -u root bash -c "echo 'host all all ${pg_hotstandby_ip}/32 md5' | sudo tee -a /var/lib/pgsql/${pg_version}/data/pg_hba.conf" 
sudo -u root bash -c "echo 'host all all ${pg_master_ip}/32 md5' | sudo tee -a /var/lib/pgsql/${pg_version}/data/pg_hba.conf" 

sudo -u root bash -c "chown postgres /var/lib/pgsql/${pg_version}/data/pg_hba.conf" 

# Restart of PostrgreSQL service
sudo systemctl stop postgresql-${pg_version}
sudo systemctl start postgresql-${pg_version}
sudo systemctl status postgresql-${pg_version}

