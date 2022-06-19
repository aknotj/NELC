class Message < ApplicationRecord
  belongs_to :user
  belongs_to :room
  has_many :notifications, dependent: :destroy

  validates :room_id, presence: true
  validates :user_id, presence: true
  validates :message, presence: true, length: {maximum: 140}

  def create_notification_message(current_user, message_id)
    recipient = Entry.where(room_id: room.id).where.not(user_id: current_user.id).find_by(room_id: room.id)
    notification = current_user.active_notifications.new(
      recipient_id: recipient.user_id,
      room_id: room.id,
      message_id: id,
      action: "message"
      )
    notification.save if notification.valid?
  end

end
