json.array!(@appointments) do |appointment|
  json.extract! appointment, :id, :title, :client_id, :user_id, :start_time, :end_time, :comments
  json.url appointment_url(appointment, format: :json)
end
