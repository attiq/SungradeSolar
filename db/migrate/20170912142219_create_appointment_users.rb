class CreateAppointmentUsers < ActiveRecord::Migration
  def change
    create_table :appointment_users do |t|
      t.string :appointment_id
      t.integer :user_id
      t.datetime :scheduled_at

      t.timestamps null: false
    end
  end
end
