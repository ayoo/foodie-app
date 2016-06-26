FactoryGirl.define do
  factory :recipe do
    title Faker::Lorem.sentence
    content Faker::Lorem.paragraph
    style Faker::Lorem.words(1)
    serves_for Faker::Number.between(1,10)
    ingredients Faker::Lorem.sentence(5)
    cook_time Faker::Number.between(5, 60)
    ready_time Faker::Number.between(1, 20)
    user
  end
end
