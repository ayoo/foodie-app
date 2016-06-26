FactoryGirl.define do
  factory :review do
    title Faker::Lorem.sentence
    content Faker::Lorem.paragraph
    place Faker::Address.street_address + ", " + Faker::Address.city
    hours Faker::Lorem.sentence
    rating Faker::Number.between(1, 5)
    tags Faker::Lorem.words(4)
    user
  end
end
