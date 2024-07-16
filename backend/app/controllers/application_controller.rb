class ApplicationController < ActionController::API
  include ExceptionHandler
  before_action :authenticate_request

  private

  def authenticate_request
    @current_user = AuthenticationService.new(request.headers).authenticate_request
  end
end
  