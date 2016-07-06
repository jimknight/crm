class AddNotifyOnInvalidJsonToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :notify_on_invalid_json, :text
  end
end
