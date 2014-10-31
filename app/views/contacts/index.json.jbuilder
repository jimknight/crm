json.array!(@contacts) do |contact|
  json.extract! contact, :id, :name, :title, :email, :work_phone, :mobile_phone, :client_id
  json.url contact_url(contact, format: :json)
end
