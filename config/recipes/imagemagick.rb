namespace :imagemagick do
  desc "Install imagemagick"
  task :install, roles: :app do
    run "#{sudo} apt-get -y install imagemagick"
  end
end