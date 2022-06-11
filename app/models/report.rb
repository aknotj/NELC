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
  
end
