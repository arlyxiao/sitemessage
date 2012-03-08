class ShortMessageReading < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  belongs_to :contact_user, :class_name => 'User', :foreign_key => :contact_user_id
  belongs_to :short_message

end
