class ShortMessagesController < ApplicationController
  def index
  end
  
  def new
    @short_message = ShortMessage.new
  end
  
  def create
    @short_message = ShortMessage.new(params[:short_message])
    return redirect_to @short_message if @short_message.save

    error = @short_message.errors.first
	  flash.now[:error] = "#{error[0]} #{error[1]}"
	  render :action => :new
  end

  def show
  end

end
