class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.text :notify_on_new_prospect_contact

      t.timestamps
    end
  end
end
