# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
# set :output, "/path/to/my/cron_log.log"
#
# every 2.hours do
#   command "/usr/bin/some_great_command"
#   runner "MyModel.some_method"
#   rake "some:great:rake:task"
# end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever

every 1.hours do
  rake "load_data:prospects", :output => {:error => 'log/cron_load_data_prospects_error.log', :standard => 'log/cron_load_data_prospects.log'}
end

# TODO - get this working later but to another destination volume
# every 1.day, :at => '11:30 pm' do
#   rake "db:backup", :output => {:error => 'log/cron_db_backup_error.log', :standard => 'log/cron_db_backup.log'}
# end
