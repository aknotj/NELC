class Public::RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_non_related, only: [:show]

  def index
    @rooms = current_user.rooms
                        .includes(:messages, entries: {user: {profile_image_attachment: :blob}})
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages.includes(user: {profile_image_attachment: :blob})
    @user = @room.users_except(current_user)
    @message = Message.new
    current_user.passive_notifications.where(room_id: @room.id).destroy_all
  end

  def create
    #paramsで送られたuserと共通のroomを探し、なければ作成
    user = User.find(params[:user_id])
    rooms = current_user.entries.pluck(:room_id)
    entry = Entry.find_by(user_id: user.id, room_id: rooms)
    unless entry.nil?
      room = Room.find(entry.room_id)
      redirect_to room_path(room)
    else
      room = Room.new
      room.save
      Entry.create(user_id: current_user.id, room_id: room.id)
      Entry.create(user_id: user.id, room_id: room.id)
      redirect_to room_path(room)
    end
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
