class CreateInvites < ActiveRecord::Migration
  def change
    create_table :invites do |t|
      t.integer :user_id
      t.integer :event_id
      t.integer :cal_id
      
      t.timestamps
    end
  end
end
