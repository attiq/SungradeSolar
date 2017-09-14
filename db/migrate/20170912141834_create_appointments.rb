class CreateAppointments < ActiveRecord::Migration
  def change
    create_table :appointments do |t|
      t.string :title
      t.integer :user_id
      t.string :app_type
      t.datetime :scheduled_at

      t.timestamps null: false
    end
  end
end
