json.array!(@clients) do |client|
  json.extract! client, :id, :name, :street1, :street2, :city, :state, :zip, :phone, :industry
  json.url client_url(client, format: :json)
end
