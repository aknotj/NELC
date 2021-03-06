class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :user, optional: true
  belongs_to :post, optional: true
  belongs_to :comment, optional: true #値が入っていなくてもよい
  belongs_to :room, optional: true
  belongs_to :message, optional: true

  default_scope -> {order('created_at desc')}
  scope :alerts, -> {where(is_checked: false).where.not(action: "message")}
  scope :chat, -> {where(action: "message")}

end
