class UsersController < ApplicationController
  respond_to :json
  before_action :load_user, :user_params, only: [:update]
  
  def index
    respond_with User.find_each
  end

  def show
  end

  def update
    if @user.update_attributes(user_params)
      render json: @user
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end

  def load_user
  	@user = User.find(params[:id])
  end
end
