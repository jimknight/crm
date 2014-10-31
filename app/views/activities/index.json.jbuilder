json.array!(@activities) do |activity|
  json.extract! activity, :id, :client_id, :activity_date, :contact_id, :city, :state, :industry, :comments
  json.url activity_url(activity, format: :json)
end
