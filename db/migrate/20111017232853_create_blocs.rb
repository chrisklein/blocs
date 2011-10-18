class CreateBlocs < ActiveRecord::Migration
  def change
    create_table :blocs do |t|
      t.string :content
      t.integer :user_id

      t.timestamps
    end
    add_index :blocs, :user_id
    add_index :blocs, :created_at
  end
end
