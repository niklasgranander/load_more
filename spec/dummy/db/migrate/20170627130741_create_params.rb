class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|

      t.timestamps null: false
    end
  end
end
