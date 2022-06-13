class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.new(message_params)
    @message.save
    redirect_back(fallback_location: root_path)
  end
  
  private
  
  def message_params
    params.require(:message).permit(:message, :room_id)
  end

end
