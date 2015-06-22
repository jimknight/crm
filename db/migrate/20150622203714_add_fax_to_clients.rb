class AddFaxToClients < ActiveRecord::Migration
  def change
    add_column :clients, :fax, :string
  end
end
