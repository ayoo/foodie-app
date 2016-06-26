require 'rails_helper'

describe RecipesController do

  context "with login" do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    describe "index" do
      context "my recipes" do
        before do
          @recipe1 = create(:recipe, user: user)
          @recipe2 = create(:recipe, user: user)
          get :index, format: :json
          @parsed_recipes = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added activities" do
          expect(@parsed_recipes.map{|a| a["id"]}).to include(@recipe1.id)
          expect(@parsed_recipes.map{|a| a["id"]}).to include(@recipe2.id)
        end
      end
      context "other's recipe" do
        before do
          other = create(:user)
          @others_recipe = create(:recipe, user: other)
          get :index, format: :json
          @parsed_recipes = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns no recipes for me" do
          expect(@parsed_recipes).to eq([])
        end
      end
    end

    describe "show" do
      context "existing recipe" do
        before do
          @recipe = create(:recipe, user: user)
          get :show, id: @recipe.id, format: :json
          @parsed_recipe = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added recipe" do
          expect(@parsed_recipe['id']).to eq(@recipe.id)
          expect(@parsed_recipe['title']).to eq(@recipe.title)
        end
      end
      context "non existing recipe" do
        before do
          get :show, id: 100, format: :json
          @parsed_recipe = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("404")
        end
      end
    end

    describe "create" do
      context "valid recipe" do
        before do
          @recipe = build(:recipe, user: user)
          post :create, {recipe: @recipe}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("201")
        end
      end
      context "non valid recipe" do
        before do
          @recipe = build(:recipe, user: user, title: nil)
          post :create, {recipe: @recipe}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "update" do
      context "existing recipe" do
        before do
          @recipe = create(:recipe, user: user)
          delete :destroy, id: @recipe.id
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns nil when trying to retrieve the deleted one" do
          deleted = Recipe.find_by(id: @recipe.id)
          expect(deleted).to be nil
        end
      end
      context "non existing recipe" do
        before do
          @recipe = create(:recipe, user: user)
          @patch = {title: nil}
          put :update, {id: @recipe.id, recipe: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "destroy" do
      context "valid recipe" do
        before do
          @recipe = create(:recipe, user: user)
          @patch = {title: "Updated title"}
          put :update, {id: @recipe.id, recipe: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the updated title of the recipe" do
          updated = Recipe.find_by(id: @recipe.id)
          expect(updated.title).to eq(@patch[:title])
        end
      end
      context "non valid recipe" do
        before do
          @recipe = create(:recipe, user: user)
          @patch = {title: nil}
          put :update, {id: @recipe.id, recipe: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
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