class Post < ApplicationRecord
  belongs_to :user
  has_many :categories, through: :post_categories
  has_many :post_categories, dependent: :destroy

  validates :user_id, presence: true
  validates :title, presence: true, length: {maximum: 50}
  validates :body, presence: true, length: {maximum: 300}

  enum language: {english: 0, japanese: 1, other: 2}

end
