class AddUniqueIndexToClientsUsers < ActiveRecord::Migration
  def change
    add_index :clients_users, [:client_id, :user_id], unique: true
  end
end
