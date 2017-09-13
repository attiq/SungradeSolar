class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer :profile_id
      t.attachment :bill

      t.timestamps null: false
    end
  end
end
