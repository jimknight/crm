class CreateContacts < ActiveRecord::Migration
  def change
    create_table :contacts do |t|
      t.string :name
      t.string :title
      t.string :email
      t.string :work_phone
      t.string :mobile_phone
      t.belongs_to :client, index: true

      t.timestamps
    end
  end
end
