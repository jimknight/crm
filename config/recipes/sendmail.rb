namespace :sendmail do
  desc "Install latest stable release of sendmail"
  task :install, roles: :web do
    run "#{sudo} apt-get -y install sendmail"
  end

  desc "Setup sendmail configuration for this application"
  %w[start stop restart].each do |command|
    desc "#{command} sendmail"
    task command, roles: :web do
      run "#{sudo} service sendmail #{command}"
    end
  end
end