namespace :db do
  desc 'Backup the database every day to /var/www/crm/backups'
  task :backup => :environment do
    puts `mkdir -p /var/www/crm/backups`
    backup_destination = "/var/www/crm/backups/crm.#{Time.now.strftime("%Y%m%d")}.dump.gz"
    sh = "pg_dump -h db -U postgres crm_production | gzip -c > #{backup_destination}"
    puts `#{sh}`
    # TODO: Copy this somewhere else
    # puts `tar czf /var/www/crm/backups/crm-uploads-$(date +%Y%m%d).tar.gz /home/sgadeploy/crm/shared/uploads/`
  end
end
