FactoryBot.define do
  factory :share do
    association :user
    association :note
    association :owner, factory: :user
  end
end
