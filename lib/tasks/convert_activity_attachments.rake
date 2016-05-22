namespace :convert do
  desc "Convert the activity attachments from the old method to the new"
  task :activity_attachments => :environment do
    Activity.all.each do |activity|
      if activity.attachment_url.present?
        puts "Activity ID##{activity.id} has old style attachment"
        if activity.activity_attachments.create!(:attachment => activity.attachment)
          puts "Converted #{activity.attachment.to_s}."
        else
          puts "Oops!"
        end
      end
    end
    puts "Done"
  end
end
