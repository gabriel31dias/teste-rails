module ExceptionHandler
    extend ActiveSupport::Concern
  
    class MissingToken < StandardError; end
    class InvalidToken < StandardError; end
  
    included do
      rescue_from ExceptionHandler::MissingToken, with: :missing_token
      rescue_from ExceptionHandler::InvalidToken, with: :invalid_token
  
      def missing_token(e)
        render json: { errors: ["Token is missing: #{e.message}"] }, status: :unauthorized
      end
  
      def invalid_token(e)
        render json: { errors: ["Invalid token: #{e.message}"] }, status: :unauthorized
      end
    end
end
  