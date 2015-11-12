class AddStatusToClient < ActiveRecord::Migration
  def change
    add_column :clients, :status, :text
  end
end
