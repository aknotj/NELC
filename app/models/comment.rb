class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :post
  has_many :reports
  
  scope :valid, -> { where(is_deleted: false) }

  validates :content, presence: true, length: {maximum: 200}

end
