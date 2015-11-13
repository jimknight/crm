class AddNotifyOnClientDeleteToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :notify_on_client_delete, :text
  end
end
