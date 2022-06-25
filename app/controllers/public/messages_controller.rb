class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = current_user.messages.new(message_params)
    if @message.save
      @message.create_notification_message(current_user, @message.id)
      redirect_back(fallback_location: root_path)
    end
  end
  
  private
  
  def message_params
    params.require(:message).permit(:message, :room_id)
  end

end
