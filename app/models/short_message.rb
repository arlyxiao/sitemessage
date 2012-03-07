class ShortMessage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id
  
  
  # --- 校验方法
  validates :sender, :receiver, :content, :presence => true
  validates_length_of :content, :maximum => 500, :message => "不能超过 %d 个字"
  
  # 对发送者隐藏信息
  def hide_sender
    self.update_attribute(:sender_hide, true)
  end
  
  # 对接收者隐藏信息
  def hide_receiver
    self.update_attribute(:receiver_hide, true)
  end
  
  # 根据用户显示消息列表
  def exchange_messages_by_user(user)
		ShortMessage.find_by_sql("
			select v.*, GREATEST(sender_id, receiver_id) as `max_user` , LEAST(sender_id, receiver_id) as `min_user` from (select * from short_messages order by id DESC) as v  where ((v.receiver_id = #{user.id} and v.receiver_hide = false ) or (v.sender_id = #{user.id} and v.sender_hide = false)) group by `max_user`,`min_user`  order by v.id DESC
		")
  end
  
  # --- 给其他类扩展的方法
  module UserMethods
    def self.included(base)
      base.has_many :short_messages, :foreign_key => :sender_id
      base.has_many :short_messages, :foreign_key => :receiver_id
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      def exchange_messages_with(user)
        ShortMessage.find(
          :all,
          :order => 'id DESC',
          :conditions => ['(sender_id = ? and sender_hide = false) or (receiver_id = ? and receiver_hide = false)', user.id, user.id]
        )
        
      end
    end
  end
  
end
