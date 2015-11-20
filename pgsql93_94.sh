sudo mkdir ~/postgresqlbk
sudo cp /etc/postgresql/9.3/main/postgresql.conf ~/postgresqlbk/
sudo cp /etc/postgresql/9.3/main/pg_hba.conf ~/postgresqlbk/

#updating repo
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" >> /etc/apt/sources.list.d/pgdg.list'

sudo apt-get update
sudo apt-get install postgresql-9.4
sudo apt-get install postgresql-contrib-9.4



#backing up whole 9.3 database
sudo su postgres
mkdir /tmp/pgdums
cd /tmp/pgdums
/usr/lib/postgresql/9.4/bin/pg_dumpall > all_data_9.3_to_9.4.dump

# Install 9.4 cluster
sudo /etc/init.d/postgresql stop
sudo pg_dropcluster 9.4 main
sudo pg_createcluster -d /data/postgres/9.4/main 9.4 main

sudo /etc/init.d/postgresql start 9.4
sudo su postgres
psql -d postgres -p 5433 -f /tmp/pgdums/all_data_9.3_to_9.4.dump

# Change port back to 5432 (optional) and the confs back to what they were! (reference previously copied files)
# enable trust login
sudo nano /etc/postgresql/9.4/main/postgresql.conf
sudo nano /etc/postgresql/9.4/main/pg_hba.conf

sudo service postgresql restart 9.4

# Drop old cluster
sudo pg_dropcluster --stop 9.3 main

# Analyze
sudo service postgresql start
psql -V