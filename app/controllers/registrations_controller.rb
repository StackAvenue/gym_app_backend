class RegistrationsController < Devise::RegistrationsController
  respond_to :json
  before_action :authenticate_user!

  def create
    build_resource(sign_up_params)
    resource.save
    render_resource(resource)
  end
end