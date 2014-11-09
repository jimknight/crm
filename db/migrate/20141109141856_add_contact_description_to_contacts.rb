class AddContactDescriptionToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :contact_description, :string
  end
end
