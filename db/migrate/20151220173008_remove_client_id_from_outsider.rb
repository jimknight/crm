class RemoveClientIdFromOutsider < ActiveRecord::Migration
  def change
    remove_column :outsiders, :client_id, :integer
  end
end
