require 'rails_helper'

RSpec.describe PersonService do
  describe '.paginate_people' do
    it 'returns paginated people with total records and total pages' do
      create_list(:person, 10)
      result = PersonService.paginate_people(page: 1, per_page: 5)

      expect(result[:people].size).to eq(5)
      expect(result[:total_records]).to eq(10)
      expect(result[:total_pages]).to eq(2)
    end
  end

  describe '.create_person' do
    context 'with valid parameters' do
      let(:valid_params) { attributes_for(:person) }

      it 'creates a new person' do
        result = PersonService.create_person(valid_params)
        expect(result[:success]).to be true
        expect(result[:person]).to be_persisted
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { attributes_for(:person, email: '') }

      it 'does not create a new person' do
        result = PersonService.create_person(invalid_params)
        expect(result[:success]).to be false
        expect(result[:errors]).to be_present
      end
    end
  end

  describe '.update_person' do
    let(:person) { create(:person) }
    let(:update_params) { { name: 'Jane Doe' } }

    context 'with valid parameters' do
      it 'updates the person' do
        result = PersonService.update_person(person, update_params)
        expect(result[:success]).to be true
        expect(result[:person].name).to eq('Jane Doe')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) { { email: '' } }

      it 'does not update the person' do
        result = PersonService.update_person(person, invalid_params)
        expect(result[:success]).to be false
        expect(result[:errors]).to be_present
      end
    end
  end

  describe '.destroy_person' do
    let!(:person) { create(:person) }

    it 'destroys the person' do
      expect { PersonService.destroy_person(person) }.to change { Person.count }.by(-1)
    end
  end
end