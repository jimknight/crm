CRM Mobile

Install Procedures

rake load_data:clients                  # Load all the clients
rake load_data:industries               # Load all the industry data
rake load_data:models                   # Load all the model data

After deploy, have to do this on the server (for now) - capistrano can be challenging.
cd /home/sgadeploy/crm/current
bundle exec rake assets:precompile RAILS_ENV=production
whenever -w
ps -aux | grep unicorn
kill <whatever the number is>
/etc/init.d/unicorn_crm start

After rails upgrade, go to /home/sgadeploy/crm/current and run
bundle install --without development test