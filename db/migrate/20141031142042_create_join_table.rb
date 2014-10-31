class CreateJoinTable < ActiveRecord::Migration
  def change
    create_join_table :activities, :models do |t|
      # t.index [:activity_id, :model_id]
      # t.index [:model_id, :activity_id]
    end
  end
end
