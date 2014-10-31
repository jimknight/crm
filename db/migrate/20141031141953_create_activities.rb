class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.belongs_to :client, index: true
      t.date_time :activity_date
      t.belongs_to :contact, index: true
      t.string :city
      t.string :state
      t.string :industry
      t.text :comments

      t.timestamps
    end
  end
end
