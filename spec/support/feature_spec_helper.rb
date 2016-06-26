module FeatureSpecHelper
  def signup_then_login
    visit "/"
    click_link "Sign up"
    email = Faker::Internet.email
    fill_in "Email", with: email
    fill_in "Password",with: "password1234"
    fill_in "Password confirmation",with: "password1234"
    fill_in "First name", with: Faker::Name.first_name
    fill_in "Last name", with: Faker::Name.last_name
    click_button "Sign up"
    expect(page).to have_content(email)
    email
  end

  def reload_page!
    page.evaluate_script("window.location.reload()")
  end
end
