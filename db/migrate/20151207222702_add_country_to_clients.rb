class AddCountryToClients < ActiveRecord::Migration
  def change
    add_column :clients, :country, :string
  end
end
