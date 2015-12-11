class CreateOutsiders < ActiveRecord::Migration
  def change
    create_table :outsiders do |t|
      t.string :email
      t.string :first_name
      t.string :last_name
      t.references :client

      t.timestamps
    end
  end
end
