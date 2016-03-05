class Api::V1::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :verify_authenticity_token
  clear_respond_to
  respond_to :json

  def facebook
    resource_class = ActiveRecord::Base::User
    self.resource = resource_class.from_omniauth(request.env['omniauth.auth'])
    if resource.persisted?
      sign_in(resource_name, resource)
      @resource = resource
      render 'api/v1/users/success'
    else
      session['devise.facebook_data'] = request.env['omniauth.auth']
      binding.pry
      redirect_to new_user_registration_url
    end
  end

  def failure
    render json: {errors: 'authentication error'}, status: 401
  end
end