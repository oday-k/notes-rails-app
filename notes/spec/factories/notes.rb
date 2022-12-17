FactoryBot.define do
  factory :note do
    text { Faker::Lorem.paragraph }
  end
end
