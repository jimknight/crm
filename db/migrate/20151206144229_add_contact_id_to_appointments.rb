class AddContactIdToAppointments < ActiveRecord::Migration
  def change
    add_reference :appointments, :contact, index: true
  end
end
