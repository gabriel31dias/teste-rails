# app/services/jwt_service.rb
class JwtService
    ALGORITHM = 'HS256'.freeze

    def self.encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      JWT.encode(payload, ENV['JWT_SECRET_KEY'], ALGORITHM)
    end
  
    def self.decode(token)
      body = JWT.decode(token, ENV['JWT_SECRET_KEY'], true, algorithm: ALGORITHM)[0]
      HashWithIndifferentAccess.new(body)
    rescue JWT::DecodeError => e
      raise ExceptionHandler::InvalidToken, e.message
    end
end
  