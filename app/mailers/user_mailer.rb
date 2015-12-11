class UserMailer < ActionMailer::Base
  default from: 'noreply@mixers.com'

  def notify_new_prospect_contact(contact,current_user)
    @user = current_user
    @client = contact.client
    @contact = contact
    @settings_doc = Setting.first
    return if @settings_doc.nil?
    @send_to = @settings_doc.notify_on_new_prospect_contact
    return if @send_to == ""
    @city = @client.city.present? ? ", #{@client.city}" : ""
    @url = prospect_url(@client)
    mail(from: @user.email, to: @send_to, subject: "New Lead: #{@client.name}#{@city}, #{contact.name}")
  end
  def notify_on_client_delete(client,recipients,current_user)
    @user = current_user
    @client = client
    @send_to = recipients
    @city = @client.city.present? ? ", #{@client.city}" : ""
    @url = client_url(@client)
    mail(from: @user.email, to: @send_to, subject: "Deletion requested for: #{@client.name}#{@city}")
  end
  def notify_rsm_new_prospect_contact_assignment(prospect,rsm,current_user)
    @user = current_user
    @prospect = prospect
    @send_to = rsm.email
    @url = prospect_url(@prospect)
    @city = @prospect.city.present? ? ", #{@prospect.city}" : ""
    mail(from: @user.email, to: @send_to, subject: "New Lead: #{@prospect.name}#{@city}")
  end
  def notify_outsider_of_prospect(prospect,outsider,current_user)
    @user = current_user
    @prospect = prospect
    @send_to = outsider.email
    @url = prospect_url(@prospect)
    @city = @prospect.city.present? ? ", #{@prospect.city}" : ""
    mail(from: @user.email, to: @send_to, subject: "New Lead: #{@prospect.name}#{@city}")
  end
end