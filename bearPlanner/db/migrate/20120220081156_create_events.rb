class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.integer :id
      t.string :name
      t.datetime :starts_at
      t.datetime :ends_at
      t.integer :owner
      
      t.timestamps
    end
  end
end
