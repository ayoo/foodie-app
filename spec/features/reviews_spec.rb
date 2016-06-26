require 'rails_helper'

feature "Reviews" do
  include FeatureSpecHelper

  before do
    email = signup_then_login
    @current_user = User.find_by(email: email)
  end

  scenario "create new review " do
    click_link("Reviews")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Review")

    click_link("New Review")
    review_title =  Faker::Lorem.sentence
    fill_in "title", with: review_title
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "place", with: Faker::Lorem.sentence
    fill_in "hours", with: Faker::Lorem.sentence
    fill_in "rating", with: Faker::Number.between(1,5)
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content(review_title)
  end

  scenario "create new review without title and see the error message" do
    click_link("Reviews")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Review")

    click_link("New Review")
    review_title =  Faker::Lorem.sentence
    fill_in "title", with: nil
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "place", with: Faker::Lorem.sentence
    fill_in "hours", with: Faker::Lorem.sentence
    fill_in "rating", with: Faker::Number.between(1,5)
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content("Title is required")
  end

  scenario "create new review without content and see the error message" do
    click_link("Reviews")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Review")

    click_link("New Review")
    review_title =  Faker::Lorem.sentence
    fill_in "title", with: review_title
    fill_in "content", with: nil
    fill_in "place", with: Faker::Lorem.sentence
    fill_in "hours", with: Faker::Lorem.sentence
    fill_in "rating", with: Faker::Number.between(1,5)
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content("Content is required")
  end

  scenario "view the existing review and edit the review" do
    my_review = create(:review, user: @current_user)
    click_link("Reviews")
    expect(page).to have_content(my_review.title)

    find(".linkable").click
    expect(page).to have_content(my_review.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Review")
    expect(page).to have_content("Delete Review")

    click_link("Edit Review")
    updated_review_title = Faker::Lorem.sentence
    fill_in "title", with: updated_review_title
    click_button "Update"
    expect(page).to have_content(updated_review_title)
  end

  scenario "delete the existing review" do
    my_review = create(:review, user: @current_user)
    click_link("Reviews")
    expect(page).to have_content(my_review.title)

    find(".linkable").click
    expect(page).to have_content(my_review.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Review")
    expect(page).to have_content("Delete Review")

    click_link("Delete Review")
    expect(page).to have_content("Do you want to delete this review?")
    find(".btn-success").click
    expect(page).not_to have_content(my_review.title)
  end
end
