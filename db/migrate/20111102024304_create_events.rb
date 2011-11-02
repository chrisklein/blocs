class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :bloc_id
      t.string :address
      t.string :phone_number
      t.string :place

      t.timestamps
    end
    add_index :events , [:bloc_id, :created_at]
  end
end
