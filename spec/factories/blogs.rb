FactoryGirl.define do
  factory :blog do
    title Faker::Lorem.sentence
    content Faker::Lorem.paragraph
    tags Faker::Lorem.words(4)
    user
  end
end
