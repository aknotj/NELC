class Report < ApplicationRecord
  belongs_to :user

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

  def subject
    if model == "user"
      User.find(subject_id).name
    elsif model == "post"
      Post.find(post_id).title
    elsif model == "comment"
      Comment.find(id: subject_id, post_id: post_id)
    end
  end

  def self.pending
    where(is_closed: false)
  end

end
