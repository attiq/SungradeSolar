class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.integer :user_id
      t.string :app_type

      t.timestamps null: false
    end
  end
end
