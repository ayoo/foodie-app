require 'rails_helper'

feature "Recent activities" do
  include FeatureSpecHelper

  scenario "see the recent blog activities created by other user" do
    @user1 = create(:user)
    @user1_activity = create(:blog, user: @user1)
    signup_then_login
    within ".activity-#{@user1_activity.id} h4.media-heading" do
      expect(page).to have_content("#{@user1.first_name} has created a blog")
    end
    within ".activity-#{@user1_activity.id} span.label-primary" do
      expect(page).to have_content("Blog")
    end
    within ".activity-#{@user1_activity.id} h4.media-heading small" do
      #expect(page).to have_content("posted on #{@blog_activity.created_at.strftime("%d/%m/%Y %I:%M")}")
    end
  end

  scenario "clicks on someone else's article in the activity list" do
    @user1 = create(:user)
    @user2_activity = create(:blog, user: @user1)
    signup_then_login
    find(".activity-#{@user2_activity.id} .linkable").click
    expect(page).to have_content(@user2_activity.title)
    expect(page).not_to have_content('Edit Blog')
    expect(page).not_to have_content('Delete Blog')
  end

  scenario "clicks on my article in the activity list" do
    email = signup_then_login
    current_user = User.find_by(email: email)
    @my_activity = create(:blog, user: current_user)
    reload_page!
    find(".activity-#{@my_activity.id} .linkable").click
    expect(page).to have_content(@my_activity.title)
    expect(page).to have_content('Edit Blog')
    expect(page).to have_content('Delete Blog')
  end
end
