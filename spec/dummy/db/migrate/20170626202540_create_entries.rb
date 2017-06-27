class CreateEntries < ActiveRecord::Migration
  def change
    create_table :entries do |t|
      t.column :string, :string
      t.timestamps null: false
    end
  end
end
