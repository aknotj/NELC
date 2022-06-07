class Public::RoomsController < ApplicationController
  before_action :reject_non_related, only: [:show]

  def index
    @rooms = current_user.rooms
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
    @message = Message.new
  end

  private

  #自分が入っている（entryがある）ルーム以外は入れない
  def reject_non_related
    @room = Room.find(params[:id])
    entries = Entry.find_by(user_id: current_user.id, room_id: @room.id)
    if entries.nil?
      redirect_to rooms_path
    end
  end

end
