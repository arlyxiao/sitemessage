class ShortMessage < ActiveRecord::Base
  # --- 校验方法
  validates :sender_id, :receiver_id, :content, :presence => { :message => "Story title is required" }

  validates_length_of :content, :maximum => 500, :message => "不能超过 %d 个字"
  
end
