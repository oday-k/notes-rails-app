FactoryBot.define do
  factory :share do
    association :user
    association :note
  end
end
