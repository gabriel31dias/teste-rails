class AuthenticationService
    def initialize(headers = {})
      @headers = headers
    end
  
    def authenticate_request
      @current_user = User.find(decoded_auth_token[:user_id]) if decoded_auth_token
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end
  
    private
  
    attr_reader :headers
  
    def decoded_auth_token

      @decoded_auth_token ||= JwtService.decode(http_auth_header)
    end
   
    def http_auth_header
      if headers['Authorization'].present?
        return headers['Authorization'].split(' ').last
      end
      raise ExceptionHandler::MissingToken, 'Missing token'
    end
end
  