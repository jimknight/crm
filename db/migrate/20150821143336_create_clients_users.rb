class CreateClientsUsers < ActiveRecord::Migration
  def change
    create_table :clients_users do |t|
      t.references :client, index: true
      t.references :user, index: true
    end
  end
end
