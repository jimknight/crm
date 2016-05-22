class CreateActivityAttachments < ActiveRecord::Migration
  def change
    create_table :activity_attachments do |t|
      t.integer :activity_id
      t.string :attachment

      t.timestamps null: false
    end
  end
end
