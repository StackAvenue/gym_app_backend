class SessionsController < Devise::SessionsController
  respond_to :json
  before_action :authenticate_user!

  def new
  	super
  end

  def create
    # super
    user = User.find_by_email(sign_in_params[:email])

    if user && user.valid_password?(sign_in_params[:password])
      @current_user = user
      render_resource(user)
    else
      render json: { data: {}, errors: { 'email or password' => ['is invalid'] } }, status: 422
    end
  end

  private

  def respond_to_on_destroy
    head :no_content
  end
end