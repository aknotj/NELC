class Notification < ApplicationRecord
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :recipient, class_name: "User", foreign_key: "recipient_id"
  belongs_to :comment, optional: true #値が入っていなくてもよい

  default_scope -> {where(is_checked: false).order('created_at desc')}

end
