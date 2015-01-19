require "rails_helper"

  describe "index" do
    it "should show a list of users" do
      3.times {|count| User.create!(:email => "user#{count}@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga")}
      @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
      visit root_path
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      click_link "Reps"
      page.should have_content User.last.email
    end
  end