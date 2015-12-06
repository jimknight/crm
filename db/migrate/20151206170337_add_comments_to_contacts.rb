class AddCommentsToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :comments, :text
  end
end
