require 'rails_helper'

describe Admin::UsersController do

  context "with admin privilege" do
    let!(:user) { create(:user, is_admin: true) }

    before do
      sign_in user
    end

    describe "index" do
      context "my users" do
        before do
          @user1 = create(:user)
          @user2 = create(:user)
          get :index, format: :json
          @parsed_users = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added activities" do
          expect(@parsed_users.map{|a| a["id"]}).to include(@user1.id)
          expect(@parsed_users.map{|a| a["id"]}).to include(@user2.id)
        end
      end
    end

    describe "show" do
      context "existing user" do
        before do
          @user = create(:user)
          get :show, id: @user.id, format: :json
          @parsed_user = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the recently added user" do
          expect(@parsed_user['id']).to eq(@user.id)
          expect(@parsed_user['email']).to eq(@user.email)
        end
      end
      context "non existing user" do
        before do
          get :show, id: 100, format: :json
          @parsed_user = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("404")
        end
      end
    end

    describe "create" do
      context "valid user" do
        before do
          @user = build(:user, password: Faker::Internet.password)
          post :create, {user: @user, password: @user.password}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("201")
        end
      end
      context "non valid user" do
        before do
          @user = build(:user, email: nil)
          post :create, {user: @user}.as_json, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "update" do
      context "valid user" do
        before do
          @user = create(:user)
          @patch = {email: Faker::Internet.email}
          put :update, {id: @user.id, user: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("200")
        end
        it "returns the updated email of the user" do
          updated = User.find_by(id: @user.id)
          expect(updated.email).to eq(@patch[:email])
        end
      end
      context "non valid user" do
        before do
          @user = create(:user)
          @patch = {email: nil}
          put :update, {id: @user.id, user: @patch }, format: :json
          @parsed = JSON.parse(response.body)
        end
        specify do
          expect(response.code).to eq("422")
        end
      end
    end

    describe "destroy" do
      before do
        @user = create(:user)
        delete :destroy, id: @user.id
        @parsed = JSON.parse(response.body)
      end
      specify do
        expect(response.code).to eq("200")
      end
      it "returns nil when trying to retrieve the deleted one" do
        deleted = User.find_by(id: @user.id)
        expect(deleted).to be nil
      end
    end

  end

  context "without admin privilege" do
    let!(:user) { create(:user)}

    describe "index" do
      before do
        get :index, format: :json
      end
      specify do
        expect(response.code).to eq("401")
      end
    end
  end

end