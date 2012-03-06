class CreateOnlineRecords < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.table_exists? 'online_records' then
			create_table :online_records,:options => "ENGINE=MEMORY" do |t|
		    t.integer  "user_id"
		    t.string   "key"
		    t.timestamps
      end
		  add_index "online_records", "key"
		  add_index "online_records", "user_id"
    end
  end
end
