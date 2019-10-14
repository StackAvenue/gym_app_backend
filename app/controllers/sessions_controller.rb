class SessionsController < Devise::SessionsController
  respond_to :json
  before_action :authenticate_user!

  def new
  	super
  end

  def create
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      @current_user = user
      # render_resource(user)
      render json: { user: user, data: user.user_info }, status: 200
    elsif user && !user.valid_password?(sign_in_params[:password])
      render json: { errors: 'you have enter invalid password' }, status: :unprocessable_entity
    else
      render json: { errors: 'you have enter invalid email' }, status: :unprocessable_entity
    end
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end