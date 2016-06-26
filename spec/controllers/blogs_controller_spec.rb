require 'rails_helper'

describe BlogsController do

  context "with login" do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    describe "index" do
      context "my blogs" do
        before do
          @blog1 = create(:blog, user: user)
          @blog2 = create(:blog, user: user)
          get :index, format: :json
          @parsed_blogs = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added activities" do
          expect(@parsed_blogs.map{|a| a["id"]}).to include(@blog1.id)
          expect(@parsed_blogs.map{|a| a["id"]}).to include(@blog2.id)
        end
      end
      context "other's blog" do
        before do
          other = create(:user)
          @others_blog = create(:blog, user: other)
          get :index, format: :json
          @parsed_blogs = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns no blogs for me" do
          expect(@parsed_blogs).to eq([])
        end
      end
    end

    describe "show" do
      context "existing blog" do
        before do
          @blog = create(:blog, user: user)
          get :show, id: @blog.id, format: :json
          @parsed_blog = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added blog" do
          expect(@parsed_blog['id']).to eq(@blog.id)
          expect(@parsed_blog['title']).to eq(@blog.title)
        end
        end
      context "non existing blog" do
        before do
          get :show, id: 100, format: :json
          @parsed_blog = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("404")
        end
      end
    end

    describe "create" do
      context "valid blog" do
        before do
          @blog = build(:blog, user: user)
          post :create, {blog: @blog}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("201")
        end
      end
      context "non valid blog" do
        before do
          @blog = build(:blog, user: user, title: nil)
          post :create, {blog: @blog}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "update" do
      context "existing blog" do
        before do
          @blog = create(:blog, user: user)
          delete :destroy, id: @blog.id
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns nil when trying to retrieve the deleted one" do
          deleted = Blog.find_by(id: @blog.id)
          expect(deleted).to be nil
        end
      end
      context "non existing blog" do
        before do
          @blog = create(:blog, user: user)
          @patch = {title: nil}
          put :update, {id: @blog.id, blog: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "destroy" do
      context "valid blog" do
        before do
          @blog = create(:blog, user: user)
          @patch = {title: "Updated title"}
          put :update, {id: @blog.id, blog: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the updated title of the blog" do
          updated = Blog.find_by(id: @blog.id)
          expect(updated.title).to eq(@patch[:title])
        end
      end
      context "non valid blog" do
        before do
          @blog = create(:blog, user: user)
          @patch = {title: nil}
          put :update, {id: @blog.id, blog: @patch }, format: :json
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