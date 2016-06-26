require 'rails_helper'

describe ReviewsController do

  context "with login" do
    let!(:user) { create(:user) }

    before do
      sign_in user
    end

    describe "index" do
      context "my reviews" do
        before do
          @review1 = create(:review, user: user)
          @review2 = create(:review, user: user)
          get :index, format: :json
          @parsed_reviews = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added activities" do
          expect(@parsed_reviews.map{|a| a["id"]}).to include(@review1.id)
          expect(@parsed_reviews.map{|a| a["id"]}).to include(@review2.id)
        end
      end
      context "other's review" do
        before do
          other = create(:user)
          @others_review = create(:review, user: other)
          get :index, format: :json
          @parsed_reviews = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns no reviews for me" do
          expect(@parsed_reviews).to eq([])
        end
      end
    end

    describe "show" do
      context "existing review" do
        before do
          @review = create(:review, user: user)
          get :show, id: @review.id, format: :json
          @parsed_review = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added review" do
          expect(@parsed_review['id']).to eq(@review.id)
          expect(@parsed_review['title']).to eq(@review.title)
        end
      end
      context "non existing review" do
        before do
          get :show, id: 100, format: :json
          @parsed_review = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("404")
        end
      end
    end

    describe "create" do
      context "valid review" do
        before do
          @review = build(:review, user: user)
          post :create, {review: @review}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("201")
        end
      end
      context "non valid review" do
        before do
          @review = build(:review, user: user, title: nil)
          post :create, {review: @review}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "update" do
      context "existing review" do
        before do
          @review = create(:review, user: user)
          delete :destroy, id: @review.id
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns nil when trying to retrieve the deleted one" do
          deleted = Review.find_by(id: @review.id)
          expect(deleted).to be nil
        end
      end
      context "non existing review" do
        before do
          @review = create(:review, user: user)
          @patch = {title: nil}
          put :update, {id: @review.id, review: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "destroy" do
      context "valid review" do
        before do
          @review = create(:review, user: user)
          @patch = {title: "Updated title"}
          put :update, {id: @review.id, review: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the updated title of the review" do
          updated = Review.find_by(id: @review.id)
          expect(updated.title).to eq(@patch[:title])
        end
      end
      context "non valid review" do
        before do
          @review = create(:review, user: user)
          @patch = {title: nil}
          put :update, {id: @review.id, review: @patch }, format: :json
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