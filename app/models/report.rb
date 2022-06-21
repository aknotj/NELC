class Report < ApplicationRecord
  belongs_to :user
  belongs_to :subject_user, class_name: "User", optional: true, foreign_key: "subject_id"
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  validates :user_id, presence: true
  validates :model, presence: true
  validates :object_id, presence: true
  validates :category, presence: true
  validates :detail, presence: true

  enum category: {offensive: 0,
                  sexual: 1,
                  discriminatory: 2,
                  impersonation: 3,
                  inappropriate: 4,
                  other: 5
                  }

  default_scope -> {order('created_at desc')}

  def self.pending
    where(is_closed: false)
  end

end
