class ApiController < ActionController::API
  include ActionController::Helpers
  helper_method :current_requester

  def current_requester
    @current_requester ||= User.find_by(api_key: request.headers['X-API-key']) if request.headers['X-API-key']
  end
end
