class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|

      t.attachment :avatar
      t.integer :user_id
      t.string :sgsID
      t.string :employeeID
      t.string :name
      t.string :phone
      t.string :signature
      t.string :stage
      t.integer :company_id
      t.string :role

      t.timestamps null: false
    end

    add_index :profiles, :employeeID
    add_index :profiles, :sgsID

  end
end
