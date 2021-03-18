#!/bin/bash

export pg_version='${pg_version}'

# Change password of postgres user
echo "postgres:${pg_password}" | chpasswd

# Setting firewall rules
sudo -u root bash -c "firewall-cmd --permanent --zone=trusted --add-source=${pg_master_ip}/32"
sudo -u root bash -c "firewall-cmd --permanent --zone=trusted --add-port=5432/tcp"
sudo -u root bash -c "firewall-cmd --reload"

# Take initial backup of database
sudo -u root bash -c "rm -rf /var/lib/pgsql/${pg_version}/data/*"
sudo -u postgres bash -c "export PGPASSWORD=${pg_replicat_password}; pg_basebackup -D /var/lib/pgsql/${pg_version}/data/ -h ${pg_master_ip} -X stream -c fast -U ${pg_replicat_username}"

# Update the content of recovery.conf
if [[ $pg_version == "13" ]]; then 
	touch /var/lib/pgsql/${pg_version}/data/standby.signal
	touch /var/lib/pgsql/${pg_version}/data/recovery.signal
	sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
    sudo -u root bash -c "chown postgres /var/lib/pgsql/${pg_version}/data/postgresql.conf"
elif [[ $pg_version == "12"  ]]; then
	touch /var/lib/pgsql/${pg_version}/data/standby.signal
	touch /var/lib/pgsql/${pg_version}/data/recovery.signal
	sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/postgresql.conf"
    sudo -u root bash -c "chown postgres /var/lib/pgsql/${pg_version}/data/postgresql.conf"
else
	sudo -u root bash -c "echo 'standby_mode = '\''on'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/recovery.conf" 
    sudo -u root bash -c "echo 'primary_conninfo  = '\''host=${pg_master_ip} port=5432 user=${pg_replicat_username} password=${pg_replicat_password}'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/recovery.conf"
    sudo -u root bash -c "echo 'recovery_target_timeline = '\''latest'\'' ' | sudo tee -a /var/lib/pgsql/${pg_version}/data/recovery.conf"
    sudo -u root bash -c "chown postgres /var/lib/pgsql/${pg_version}/data/recovery.conf"
fi

# Restart of PostrgreSQL service
sudo systemctl enable postgresql-${pg_version}
sudo systemctl stop postgresql-${pg_version}
sudo systemctl start postgresql-${pg_version}
sudo systemctl status postgresql-${pg_version}

if [[ $pg_version == "9.6" ]]; then 
	sudo -u root bash -c "tail -5 /var/lib/pgsql/${pg_version}/data/pg_log/postgresql-*.log"
else
	sudo -u root bash -c "tail -5 /var/lib/pgsql/${pg_version}/data/log/postgresql-*.log"
fi
