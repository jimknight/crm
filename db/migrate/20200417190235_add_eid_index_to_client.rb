class AddEidIndexToClient < ActiveRecord::Migration
  def change
    add_index :clients, :eid
  end
end
