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
          :conditions => ['(sender_hide = false and sender_id = ?) or (receiver_hide = false and receiver_id = ?)', user.id, user.id]
        )
      end
      
      def exchange_messages
        
      end
    end
  end
  
end
