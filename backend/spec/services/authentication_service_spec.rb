require 'rails_helper'

RSpec.describe AuthenticationService do
  let(:user) { create(:user) }
  let(:headers) { { 'Authorization' => "Bearer #{JwtService.encode(user_id: user.id)}" } }
  let(:invalid_headers) { { 'Authorization' => 'Bearer invalid_token' } }

  describe '#authenticate_request' do
    context 'with valid token' do
      it 'returns the current user' do
        service = AuthenticationService.new(headers)
        expect(service.authenticate_request).to eq(user)
      end
    end

    context 'with invalid token' do
      it 'raises an InvalidToken error' do
        service = AuthenticationService.new(invalid_headers)
        expect { service.authenticate_request }.to raise_error(ExceptionHandler::InvalidToken)
      end
    end

    context 'with missing token' do
      it 'raises a MissingToken error' do
        service = AuthenticationService.new({})
        expect { service.authenticate_request }.to raise_error(ExceptionHandler::MissingToken)
      end
    end
  end
end
