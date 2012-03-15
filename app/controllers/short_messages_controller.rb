class ShortMessagesController < ApplicationController
  # 显示当前用户所有短消息记录列表
  def index
    @messages = current_user.all_exchanged_last_messages
  end
  
  def new
    @short_message = ShortMessage.new
    @receiver = User.find_by_id(params[:receiver_id])
  end
  
  def create
    @short_message = ShortMessage.new(params[:short_message])
    @short_message.sender = current_user
    #return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}" if @short_message.save
    if @short_message.save
      Juggernaut.publish("/receiver#{@short_message.receiver_id}_sender#{current_user.id}", @short_message.content)
      return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}"
    end

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
    @short_message = ShortMessage.find(params[:id])
    short_message_reading = ShortMessageReading.find_by_user_id_and_short_message_id(current_user.id, params[:id])
    short_message_reading.destroy
    
    return redirect_to "/short_messages/exchange?receiver_id=#{@short_message.receiver_id}"
  end

end
