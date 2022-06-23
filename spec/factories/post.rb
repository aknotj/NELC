FactoryBot.define do
  factory :post do
    title {'title'}
    body {'body'}
    association :user
  end
end