class ShortMessageReading < ActiveRecord::Base
  # --- 模型关联
  belongs_to :user
  belongs_to :contact_user, :class_name => 'User', :foreign_key => :contact_user_id
  belongs_to :short_message
  
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :short_message_readings, :foreign_key => :receiver_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def all_exchanged_last_messages
				ShortMessageReading.find(
					:all,
					:group => 'contact_user_id',
					:order => 'id DESC'
				).map{|x| x.short_message}
			end
		
			def exchanged_messages_with(contact_user)
				ShortMessageReading.find(
					:all,
					:conditions => ['contact_user_id = ?', contact_user.id],
					:order => 'id DESC'
				).map{|x| x.short_message}
			end
    end
  end

end
