require 'rails_helper'

feature "Blogs" do
  include FeatureSpecHelper

  before do
    email = signup_then_login
    @current_user = User.find_by(email: email)
  end

  scenario "create new blog " do
    click_link("Blogs")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Blog")

    click_link("New Blog")
    blog_title =  Faker::Lorem.sentence
    fill_in "title", with: blog_title
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content(blog_title)
  end

  scenario "create new blog without title and see the error message" do
    click_link("Blogs")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Blog")

    click_link("New Blog")
    blog_title =  Faker::Lorem.sentence
    fill_in "title", with: nil
    fill_in "content", with: Faker::Lorem.paragraph
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content("Title is required")
  end

  scenario "create new blog without content and see the error message" do
    click_link("Blogs")
    expect(page).not_to have_selector(".media")
    expect(page).to have_content("New Blog")

    click_link("New Blog")
    blog_title =  Faker::Lorem.sentence
    fill_in "title", with: blog_title
    fill_in "content", with: nil
    fill_in "tags", with: Faker::Lorem.word
    click_button "Create"
    expect(page).to have_content("Content is required")
  end

  scenario "view the existing blog and edit the blog" do
    my_blog = create(:blog, user: @current_user)
    click_link("Blogs")
    expect(page).to have_content(my_blog.title)

    find(".linkable").click
    expect(page).to have_content(my_blog.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Blog")
    expect(page).to have_content("Delete Blog")

    click_link("Edit Blog")
    updated_blog_title = Faker::Lorem.sentence
    fill_in "title", with: updated_blog_title
    click_button "Update"
    expect(page).to have_content(updated_blog_title)
  end

  scenario "delete the existing blog" do
    my_blog = create(:blog, user: @current_user)
    click_link("Blogs")
    expect(page).to have_content(my_blog.title)

    find(".linkable").click
    expect(page).to have_content(my_blog.title)
    expect(page).to have_content("by #{@current_user.first_name} #{@current_user.last_name}")
    expect(page).to have_content("Edit Blog")
    expect(page).to have_content("Delete Blog")

    click_link("Delete Blog")
    expect(page).to have_content("Do you want to delete this blog?")
    find(".btn-success").click
    expect(page).not_to have_content(my_blog.title)
  end
end
