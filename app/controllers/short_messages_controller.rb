class ShortMessagesController < ApplicationController
  # 显示当前用户所有短消息记录列表
  def index
  end
  
  def new
    @short_message = ShortMessage.new
    @receiver_id = params[:receiver_id]
  end
  
  def create
    @short_message = ShortMessage.new(params[:short_message])
    @short_message.sender = current_user
    return redirect_to @short_message if @short_message.save

    error = @short_message.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  
  # 与某个用户交流记录列表
  def exchange
    @short_message = ShortMessage.find_by_receiver_id(params[:receiver_id])
    if @short_message
      @messages = current_user.exchange_messages_with(@short_message.receiver)
    else
      render :action => :index
    end
    
  end
  
  def destroy
    @short_message = ShortMessage.find(params[:id]) if params[:id]
    @short_message.hide_sender if current_user == @short_message.sender
    @short_message.hide_receiver if current_user == @short_message.receiver
    
    return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}"
  end

end
