class UserDetailsController < ApplicationController
  respond_to :json
  before_action :load_user, only: [:create]
  before_action :load_user_details, only: [:update, :destroy]
  
  def index
    respond_with UserDetails.find_each
  end

  def show
  end

  def create
    user_details = @user.user_details.new(user_details_params)
    if user_details.save
      render json: user_details
    else
      render json: { errors: 'user details not saved, please try again.' }, status: :unprocessable_entity
    end
  end

  def update
    if @user_details.update_attributes(user_details_params)
      render json: @user_details
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_details_params
    params.require(:user_details).permit(:age, :height, :weight)
  end

  def load_user_details
    @user_details = UserDetails.find(params[:id])
  end

  def load_user
  	@user = User.find(params[:user_id])
  end
end
