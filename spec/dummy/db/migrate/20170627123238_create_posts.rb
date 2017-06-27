class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :string
      t.references :entry
      t.timestamps null: false
    end
  end
end
