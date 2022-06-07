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

  def create
    rooms = current_user.entries.pluck(:room_id)
    entries = Entry.find_by(user_id: @user.id, room_id: rooms)
    unless entries.nil?
      @room = entries.room
    else
      @room = Room.new
      @room.save
      Entry.create(user_id: current_user.id, room_id: @room.id)
      Entry.create(user_id: @user.id, room_id: @room.id)
    end
    redirect_to room_path(@room)
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
