namespace :users do
  desc "Create profiles for existing users if they don't have one"
  task :create_missing_profiles => :environment do
    User.all.each do |user|
      if user.profile.nil?
        profile = Profile.create!(:first_name => "", :last_name => "")
        user.profile = profile
      end
    end
    puts "Done"
  end
end