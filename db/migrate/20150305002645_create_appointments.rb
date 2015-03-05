class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :title
      t.belongs_to :client, index: true
      t.belongs_to :user, index: true
      t.datetime :start_time
      t.datetime :end_time
      t.text :comments

      t.timestamps
    end
  end
end
