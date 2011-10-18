class CreateBlocposts < ActiveRecord::Migration
  def change
    create_table :blocposts do |t|
      t.string :content
      t.integer :user_id
      t.integer :bloc_id

      t.timestamps
    end
    add_index :blocposts, :bloc_id
    add_index :blocposts, :created_at
  end
end
