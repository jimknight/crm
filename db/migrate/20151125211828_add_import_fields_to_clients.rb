class AddImportFieldsToClients < ActiveRecord::Migration
  def change
    add_column :clients, :eid, :string
    add_column :clients, :prospect_type, :text
    add_column :clients, :source, :text
    add_column :clients, :form_dump, :text
    add_column :clients, :import_datetime, :datetime
  end
end
