# CRM Mobile

### Install Procedures

* rake load_data:clients                  # Load all the clients
* rake load_data:industries               # Load all the industry data
* rake load_data:models                   # Load all the model data

### After deploy, have to do this on the server (for now) - capistrano can be challenging.
* cd /home/sgadeploy/crm/current
* bundle install --without development test
* bundle exec rake assets:precompile RAILS_ENV=production
* whenever -w
* ps -aux | grep unicorn
* kill <whatever the number is>
* /etc/init.d/unicorn_crm start

### After rails upgrade, go to /home/sgadeploy/crm/current and run
* bundle install --without development test

### Migrations
* bundle exec rake db:migrate RAILS_ENV=production

### Replace SSL cert
#### From local, put rossmixing.crt certificate on the server somewhere:
* scp rossmixing.crt sgadeploy@crm.rossmixing.com:~/.

#### Go to the server and open the root dir
* cd
* sudo service nginx stop
* sudo mv rossmixing.crt /etc/nginx/ssl
* sudo service nginx start
* /etc/init.d/unicorn_crm start

### Mac dev for tests
* For capybara-webkit need qt 5.5
* https://github.com/thoughtbot/capybara-webkit/wiki/Installing-Qt-and-compiling-capybara-webkit

#### Postgres on server
* psql (PostgreSQL) 9.3.17

#### Ruby on server
* ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]

### Docker
* docker-compose run app bundle exec rake db:create
* docker-compose run app bundle exec rake db:migrate
* docker-compose run app psql -h db -U postgres crm_development < crm_production.dump

### Docker production
* dcprod = docker-compose -f docker-compose.prod.yml
* dcprod run app bundle exec rake db:create
* dcprod run app bundle exec rake db:migrate
* bundle exec rake assets:precompile
* dcprod run app psql -h db -U postgres crm_production < crm_production.dump

### Set up the ec2 instance
* sudo yum install docker
* sudo yum install git
* sudo systemctl start docker
* sudo systemctl enable docker
** Created symlink from /etc/systemd/system/multi-user.target.wants/docker.service to /usr/lib/systemd/system/docker.service.

#### docker-compose
* https://docs.docker.com/compose/install/#install-compose
* sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o
* sudo chmod +x /usr/local/bin/docker-compose
* docker-compose --version
* sudo usermod -aG docker ${USER}

### Login
ssh -i "crmrossmixingcom.pem" ec2-user@34.238.211.171

### Auto restart on boot
@reboot (sleep 30s ; cd /home/ec2-user/crm ; /usr/local/bin/docker-compose -f docker-compose.prod.yml up -d )&

### Rails console in production
dcprod run app rails console production

### Postgres console in production
dcprod run app psql -h db -U postgres crm_production

### Backup and restore
* pg_dump -h localhost -U postgres crm_production | gzip -c > /home/sgadeploy/backups/crm.2018-12-08.dump.gz
* dcprod run app dropdb -U postgres -h db crm_production
* dcprod run app createdb -U postgres -h db -T template0 crm_production
* dcprod run app bash
* cat ./crm.2018-12-08.dump.gz | gunzip | psql -h db -U postgres crm_production

### Old IP
* 72.28.113.176

### Test outbound email to jim
UserMailer.test_email_to_jim().deliver_now()

### View the docker volumes
* There is one for the postgres data and one for the uploads data

[ec2-user@ip-10-0-0-245 public]$ docker volume ls
DRIVER              VOLUME NAME
local               crm_postgres_data
local               crm_uploads_data

[ec2-user@ip-10-0-0-245 public]$ docker volume inspect crm_uploads_data
[
    {
        "CreatedAt": "2018-12-21T01:59:02Z",
        "Driver": "local",
        "Labels": {
            "com.docker.compose.project": "crm",
            "com.docker.compose.version": "1.23.1",
            "com.docker.compose.volume": "uploads_data"
        },
        "Mountpoint": "/var/lib/docker/volumes/crm_uploads_data/_data",
        "Name": "crm_uploads_data",
        "Options": null,
        "Scope": "local"
    }
]

Need sudo to get access to it
[ec2-user@ip-10-0-0-245 public]$ sudo ls /var/lib/docker/volumes/crm_uploads_data/_data -lsa
total 0
0 drwxrwxr-x 4 root root 44 Dec 21 01:59 .
0 drwxr-xr-x 3 root root 19 Dec 21 01:59 ..
0 drwxr-xr-x 3 root root 24 Dec 21 01:59 activity_attachment
0 drwxr-xr-x 2 root root  6 Dec 21 18:35 tmp

Here's where the files are right now
[ec2-user@ip-10-0-0-245 public]$ sudo ls /var/lib/docker/volumes/crm_uploads_data/_data/activity_attachment/attachment
4198  4199  4200  4202	4203  4204  4205  4206	4207  4208  4209

# Copy from my other location
sudo cp -r ~/crm_uploads_from_before_aws/activity_attachment/attachment /var/lib/docker/volumes/crm_uploads_data/_data/activity_attachment/

### Get the missing clients
* https://richonrails.com/articles/exporting-to-csv-using-ruby-on-rails-3-and-ruby-1-9
require 'csv'
def self.as_csv
  CSV.generate do |csv|
    csv << column_names
    all.each do |item|
      csv << item.attributes.values_at(*column_names)
    end
  end
end
@clients = Client.order(:created_at)
File.open("clients.csv", "w+") do |f|
  f << @clients.as_csv
end

### Get the missing contacts
@contacts = Contact.order(:created_at)
File.open("contacts.csv", "w+") do |f|
  f << @contacts.as_csv
end
