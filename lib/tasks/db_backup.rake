namespace :db do
  desc 'Backup the database every day to /home/sgadeploy/backups'
  task :backup => :environment do
    backup_destination = "/home/sgadeploy/backups/crm.#{Time.now.strftime("%Y%m%d")}.dump.gz"
    sh = "pg_dump -h localhost -U postgres crm_production | gzip -c > #{backup_destination}"
    puts `#{sh}`
    puts `tar czf /home/sgadeploy/backups/crm-uploads-$(date +%Y%m%d).tar.gz /home/sgadeploy/crm/shared/uploads/`
  end
end