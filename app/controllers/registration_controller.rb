class RegistrationController < ApplicationController
  def update
    user = User.find(params[:user])
    user.update(authenticated: true)
    if user.authenticated
      flash[:success] = 'Thank you for authenticating your account!'
    end
    redirect_to dashboard_path
  end
end
