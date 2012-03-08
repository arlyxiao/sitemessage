class CreateShortMessageReadings < ActiveRecord::Migration
  def change
    create_table :short_message_readings do |t|
      t.integer :short_message_id
      t.integer :user_id
      t.integer :contact_user_id
      t.boolean :is_read, :default => false
      
      t.timestamps
    end
  end
end
