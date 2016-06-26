FactoryGirl.define do
  factory :user do
    sequence(:email) { |i| "#{Faker::Internet.user_name}#{i}@example.com" }
    password "foobarcar"
    first_name Faker::Name.first_name
    last_name Faker::Name.last_name
  end
end
