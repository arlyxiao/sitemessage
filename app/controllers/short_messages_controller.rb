class ShortMessagesController < ApplicationController
  # 显示当前用户所有短消息记录列表
  def index
    @messages = current_user.all_exanged_last_messages
    # 把方法定义改到user上了，这样语义上比较好，不用new对象
  end
  
  def new
    @short_message = ShortMessage.new
    @receiver = User.find_by_id(params[:receiver_id])
  end
  
  def create
    @short_message = ShortMessage.new(params[:short_message])
    @short_message.sender = current_user
    return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}" if @short_message.save

    error = @short_message.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  
  # 与某个用户交流记录列表
  def exchange
    @receiver = User.find_by_id(params[:receiver_id])
    
    if !@receiver.blank?
      @exchanged_messages = current_user.exchanged_messages_with(@receiver)
      return
    end
    
    render :text => '未指定用户'
  end
  
  def destroy
    @short_message = ShortMessage.find(params[:id]) if params[:id]
    @short_message.hide_sender if current_user == @short_message.sender
    @short_message.hide_receiver if current_user == @short_message.receiver
    
    return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}"
  end

end
