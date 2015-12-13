namespace :remove_duplicates do
  desc "Fix the duplicate associations"
  task :clients_users => :environment do
    Client.all.each do |c|
      # get all the users uniquely
      users_unique = c.users.uniq
      # remove all the users in the association
      c.users.each do |user|
        c.users.delete(user)
      end
      # add users back in
      users_unique.each do |user|
        puts "Add #{user.email} back into association with #{c.name}"
        c.users << user
      end
    end
    puts "Done"
  end
end