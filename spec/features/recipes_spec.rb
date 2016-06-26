require 'rails_helper'

feature "Recipes" do
  include FeatureSpecHelper

  before do
    email = signup_then_login
    @current_user = User.find_by(email: email)
  end

  scenario "create new recipe " do
    click_link("Recipes")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Recipe")

    click_link("New Recipe")
    recipe_title =  Faker::Lorem.sentence
    fill_in "title", with: recipe_title
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "style", with: Faker::Lorem.sentence
    fill_in "serves_for", with: Faker::Number.between(1,10)
    fill_in "ingredients", with: Faker::Lorem.sentences(4)
    fill_in "cook_time", with: Faker::Number.between(5,60)
    fill_in "ready_time", with: Faker::Number.between(5,20)
    click_button "Create"
    expect(page).to have_content(recipe_title)
  end

  scenario "create new recipe without title and see the error message" do
    click_link("Recipes")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Recipe")

    click_link("New Recipe")
    recipe_title =  Faker::Lorem.sentence
    fill_in "title", with: nil
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "style", with: Faker::Lorem.sentence
    fill_in "serves_for", with: Faker::Number.between(1,10)
    fill_in "ingredients", with: Faker::Lorem.sentences(4)
    fill_in "cook_time", with: Faker::Number.between(5,60)
    fill_in "ready_time", with: Faker::Number.between(5,20)
    click_button "Create"
    expect(page).to have_content("Title is required")
  end

  scenario "create new recipe without content and see the error message" do
    click_link("Recipes")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Recipe")

    click_link("New Recipe")
    recipe_title =  Faker::Lorem.sentence
    fill_in "title", with: recipe_title
    fill_in "content", with: nil
    fill_in "style", with: Faker::Lorem.sentence
    fill_in "serves_for", with: Faker::Number.between(1,10)
    fill_in "ingredients", with: Faker::Lorem.sentences(4)
    fill_in "cook_time", with: Faker::Number.between(5,60)
    fill_in "ready_time", with: Faker::Number.between(5,20)
    click_button "Create"
    expect(page).to have_content("Content is required")
  end

  scenario "view the existing recipe and edit the recipe" do
    my_recipe = create(:recipe, user: @current_user)
    click_link("Recipes")
    expect(page).to have_content(my_recipe.title)

    find(".linkable").click
    expect(page).to have_content(my_recipe.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Recipe")
    expect(page).to have_content("Delete Recipe")

    click_link("Edit Recipe")
    updated_recipe_title = Faker::Lorem.sentence
    fill_in "title", with: updated_recipe_title
    click_button "Update"
    expect(page).to have_content(updated_recipe_title)
  end

  scenario "delete the existing recipe" do
    my_recipe = create(:recipe, user: @current_user)
    click_link("Recipes")
    expect(page).to have_content(my_recipe.title)

    find(".linkable").click
    expect(page).to have_content(my_recipe.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Recipe")
    expect(page).to have_content("Delete Recipe")

    click_link("Delete Recipe")
    expect(page).to have_content("Do you want to delete this recipe?")
    find(".btn-success").click
    expect(page).not_to have_content(my_recipe.title)
  end
end
