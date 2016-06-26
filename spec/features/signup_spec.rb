require 'rails_helper'

feature "dashboard" do
  scenario "sign up, go to the homepage, log out" do
    visit "/"
    expect(page).to have_content("Log in")
    click_link "Sign up"
    email = Faker::Internet.email
    fill_in "Email", with: email
    fill_in "Password",with: "password1234"
    fill_in "Password confirmation",with: "password1234"
    fill_in "First name", with: Faker::Name.first_name
    fill_in "Last name", with: Faker::Name.last_name
    click_button "Sign up"
    expect(page).to have_content(email)
    click_link "Log Out"
    expect(page).not_to have_content(email)
    expect(page).to have_content("Log in")
  end

  scenario "sign up using a bad email and password" do
    visit "/"
    expect(page).to have_content("Log in")
    click_link "Sign up"
    email = Faker::Internet.email
    fill_in "Email", with: email
    fill_in "Password",with: "1234"
    fill_in "Password confirmation",with: "1234"
    click_button "Sign up"
    expect(page).to have_content "Password is too short (minimum is 6 characters)"
  end

  scenario "log in incorrectly" do
    visit "/"
    expect(page).to have_content("Log in")
    click_button "Log in"
    expect(page).to have_content("Invalid Email or password")
  end
end