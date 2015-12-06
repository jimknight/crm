class AddWorkPhoneExtensionToContacts < ActiveRecord::Migration
  def change
    add_column :contacts, :work_phone_extension, :string
  end
end
