require "rails_helper"

  describe "create" do
    it "should allow the creation of a new user for admins" do
      User.destroy_all
      Profile.destroy_all
      Activity.destroy_all
      @admin = User.create!(:email => "admin@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
      visit root_path
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      click_link "Reps"
      click_link "Add Rep"
      fill_in "Email", :with => "jmaio@sga.com"
      fill_in "First name", :with => "Joe"
      fill_in "Last name", :with => "Maio"
      fill_in "Password", :with => "ilovesga"
      fill_in "Password confirmation", :with => "ilovesga"
      click_button "Save"
      page.should have_content "Joe Maio"
    end
    it "should show the correct error message if the user enters the wrong password_confirmation" do
      User.destroy_all
      Profile.destroy_all
      Activity.destroy_all
      @admin = User.create!(:email => "admin@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
      visit root_path
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      click_link "Reps"
      click_link "Add Rep"
      fill_in "Email", :with => "jmaio@sga.com"
      fill_in "First name", :with => "Joe"
      fill_in "Last name", :with => "Maio"
      fill_in "Password", :with => "ilovesga"
      fill_in "Password confirmation", :with => "this password doesn't match"
      click_button "Save"
      page.should have_content "New Rep"
      page.should have_content "Your passwords don't match"
      save_and_open_page
    end
  end

  describe "index" do
    before :each do
      User.destroy_all
      Profile.destroy_all
      Activity.destroy_all
      3.times {|count| User.create!(:email => "user#{count}@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga")}
      @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    end
    it "should show a list of users" do
      visit root_path
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      click_link "Reps"
      page.should have_content User.last.email
    end
  end

  describe "show" do
    before :each do
      User.destroy_all
      Profile.destroy_all
      @user1 = User.create!(:email => "user1@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga")
      @user2 = User.create!(:email => "user2@sga.com",:password => "ilovesga", :password_confirmation => "ilovesga")
      @admin = User.create!(:email => "admin@sga.com", :password => "ilovesga", :password_confirmation => "ilovesga", :admin => true)
    end
    it "should only allow editing of a particular profile by that user or admin" do
      # owner user
      @profile = @user1.profile
      visit edit_profile_path(@profile)
      fill_in "Email", :with => "user1@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should have_content "Editing rep"
      click_link "Logout"
      # other user
      visit edit_profile_path(@profile)
      fill_in "Email", :with => "user2@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should have_content "not authorized"
      click_link "Logout"
      # admin
      visit edit_profile_path(@profile)
      fill_in "Email", :with => "admin@sga.com"
      fill_in "Password", :with => "ilovesga"
      click_button "Sign in"
      page.should have_content "Editing rep"
    end
  end