class ShortMessage < ActiveRecord::Base
  # --- 模型关联
  belongs_to :sender, :class_name => 'User', :foreign_key => :sender_id
  belongs_to :receiver, :class_name => 'User', :foreign_key => :receiver_id
  
  
  # --- 校验方法
  validates :sender, :receiver, :content, :presence => true
  validates_length_of :content, :maximum => 500, :message => "不能超过 %d 个字"
  
  # --- SCOPE
  scope :sender_visible, where(:sender_hide => false)
  scope :receiver_visible, where(:receiver_hide => false)
  
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
      # base.has_many :short_messages, :foreign_key => :sender_id
      # base.has_many :short_messages, :foreign_key => :receiver_id
      # 不能这样针对不同的 key 重复声明同名的has_many，需要声明不同的名称。
      # 暂时也没有用到，先注释掉了
      
      base.send(:include, InstanceMethods)
    end
    
    module InstanceMethods
      
      # 显示指定用户的消息会话列表
      # 定义在 user 上，语义性比较好
      def all_exanged_last_messages
    
        ShortMessage.find(
          :all,
          :order => 'id DESC',
          :group => 'sender_id, receiver_id',
          :conditions => [
            %~
              (sender_id = ? AND sender_hide IS FALSE)
              OR
              (receiver_id = ? AND receiver_hide IS FALSE)
            ~,
            self.id, self.id
          ]
        )
        # 查询可以简化成这样，SCOPE似乎也不太好用上，我继续考虑一下设计上的改进吧
      end
      
      def exchanged_messages_with(user)
        ShortMessage.find(
          :all,
          :order => 'id DESC',
          :conditions => [
            %~
              (sender_id = ? AND receiver_id = ? AND sender_hide IS FALSE)
              OR 
              (sender_id = ? AND receiver_id = ? AND receiver_hide IS FALSE)
            ~, 
            self.id, user.id, # 由我发送的消息
            user.id, self.id  # 由我接收的消息
          ]
        )
      end
    end
  end
  
end
