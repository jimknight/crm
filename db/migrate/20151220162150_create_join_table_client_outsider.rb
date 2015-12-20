class CreateJoinTableClientOutsider < ActiveRecord::Migration
  def change
    create_join_table :clients, :outsiders do |t|
      t.index [:client_id, :outsider_id]
      t.index [:outsider_id, :client_id]
    end
  end
end
