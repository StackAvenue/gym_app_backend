class UsersController < ApplicationController
  respond_to :json
  before_action :user_params, only: [:update]
  before_action :load_user, only: [:update, :show, :destroy]
  
  def index
    respond_with User.find_each
  end

  def show
    if @user.present?
      render json: { details: @user.user_info, role: @user.role_name, all_users: @user.all_users, role_lists: @user.role_lists, trainer_lists: @user.trainer_lists }
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update_attributes(user_params)
      render json: @user.user_slice_info
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :role_id)
  end

  def load_user
  	@user = User.find(params[:id])
  end
end
