class CreateShortMessages < ActiveRecord::Migration
  def change
    create_table :short_messages do |t|
      t.integer :sender_id
      t.integer :receiver_id
      t.text :content
      t.boolean :sender_read, :default => false
      t.boolean :receiver_read, :default => false
      t.boolean :sender_hide, :default => false
      t.boolean :receiver_hide, :default => false

      t.timestamps
    end
  end
end
