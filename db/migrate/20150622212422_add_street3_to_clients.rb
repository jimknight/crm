class AddStreet3ToClients < ActiveRecord::Migration
  def change
    add_column :clients, :street3, :string
  end
end
