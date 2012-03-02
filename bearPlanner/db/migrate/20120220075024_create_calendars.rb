class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|
      t.string :name #with a column called "name" of type "string"
			t.string :description
      t.integer :user_id
      t.timestamps
    end
  end
end
