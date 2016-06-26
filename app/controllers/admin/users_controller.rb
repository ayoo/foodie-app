class Admin::UsersController < ApplicationController
  before_action :verify_admin!

  def verify_admin!
    unless current_user.is_admin?
      raise AdminAccessRequiredError
    end
  end

  def index
    @users = User.all.order('last_name')
    render json: @users
  end

  def show
    user = User.find_by(id: params[:id])
    if user
      render json: user
    else
      render status: 404, json: {error: "User not found"}
    end
  end

  def create
    user = User.new(admin_users_params)
    if user.save
      render status: 201, json: { message: "User was created successfully" }
    else
      render status: 422,  json: {error: user.errors.full_messages}
    end
  end

  def update
    user = User.find_by(id: params[:id])
    if user.update_attributes(admin_users_params)
      render status: 200, json: { message: "User was updated successfully" }
    else
      render status: 422,  json: {error: user.errors.full_messages}
    end
  end

  def destroy
    user = User.find_by(id: params[:id])
    if user.update_attribute(:deleted_at, Time.zone.now)
      render status: 200, json: { message: "User was deleted successfully" }
    else
      render status: 422,  json: {error: user.errors.full_messages}
    end
  end

  private
    def admin_users_params
      params[:user][:password] = params[:password]
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :first_name, :last_name, :is_admin)
    end
end

class AdminAccessRequiredError < StandardError;end