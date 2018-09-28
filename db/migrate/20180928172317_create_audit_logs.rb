class CreateAuditLogs < ActiveRecord::Migration
  def change
    create_table :audit_logs do |t|
      t.integer :user_id
      t.string :action
      t.string :email
      t.string :controller
      t.string :message

      t.timestamps null: false
    end
  end
end
