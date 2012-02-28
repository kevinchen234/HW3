class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.datetime :starts
      t.datetime :ends
      t.string :owner
      
      t.timestamps
    end
  end
end
