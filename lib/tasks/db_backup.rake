namespace :db do
  desc 'Backup the database every day to /home/sgadeploy/backups'
  task :backup => :environment do
    backup_destination = "/home/sgadeploy/backups/crm.#{Tim.now.strftime("%Y%m%d")}.dump.gz"
    sh = "#{pg_dump} crm_production | gzip -c #{backup_destination}"
    puts `#{sh}`
  end
end