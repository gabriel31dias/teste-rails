require 'rails_helper'

RSpec.describe JwtService do
  let(:payload) { { user_id: 1 } }
  let(:token) { JwtService.encode(payload) }

  describe '.encode' do
    it 'returns a JWT token' do
      expect(token).to be_a(String)
    end
  end

  describe '.decode' do
    it 'decodes a JWT token' do
      decoded_payload = JwtService.decode(token)
      expect(decoded_payload['user_id']).to eq(payload[:user_id])
    end

    it 'raises an error for an invalid token' do
      expect { JwtService.decode('invalid_token') }.to raise_error(ExceptionHandler::InvalidToken)
    end
  end
end
