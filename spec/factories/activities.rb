FactoryGirl.define do
  factory :activity do
    user
    action { ['created','updated','deleted'].sample }
    title Faker::Lorem.sentence(5)
  end
end
