json.array!(@clients) do |client|
  json.extract! client, :id, :name, :street1, :street2, :stree3, :city, :state, :zip, :phone, :fax, :industry
  json.url client_url(client, format: :json)
end
