require 'rails_helper'

describe ActivitiesController do

  context "with login" do
    describe "index" do
      before do
        user = create(:user)
        sign_in user
        @blog = create(:blog)
        @recipe = create(:recipe)
        @review = create(:review)
      end

      context "html" do
        before do
          get :index
        end
        specify do
          expect(response.code).to eq("200")
          expect(assigns(:activities)).to be nil
          expect(response).to render_template(:index)
        end
      end

      context "json" do
        before do
          get :index, format: :json
          @parsed_activities = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added activities" do
          expect(@parsed_activities.map{|a| a["streamable_id"]}).to include(@blog.id)
          expect(@parsed_activities.map{|a| a["streamable_id"]}).to include(@recipe.id)
          expect(@parsed_activities.map{|a| a["streamable_id"]}).to include(@review.id)
        end
      end
    end
  end

  context "without login" do
    describe "index" do
      context "html" do
        before do
          get :index
        end
        specify do
          expect(response.code).to eq("302")
          expect(response).to redirect_to("/users/sign_in")
        end
      end
      context "json" do
        before do
          get :index, format: :json
        end
        specify do
          expect(response.code).to eq("401")
        end
      end
    end
  end

end