# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Contact, type: :model do
  let(:contact) { build_stubbed(:contact) }

  describe 'assoications' do
    it 'has one FOI request' do
      expect(contact.build_foi_request).to be_a FoiRequest
    end

    it 'removes FOI request on destroy' do
      contact = create(:foi_request).contact
      expect { contact.destroy }.to change { FoiRequest.count }.by(-1)
    end
  end

  describe 'attributes' do
    it 'requires an email' do
      contact.email = nil
      expect(contact.valid?).to eq false
      expect(contact.errors[:email]).to_not be_empty
    end

    it 'requires an full name' do
      contact.full_name = nil
      expect(contact.valid?).to eq false
      expect(contact.errors[:full_name]).to_not be_empty
    end

    context 'checks the format of an email' do
      it 'rejects invalid formatted email' do
        contact.email = 'invalid'
        expect(contact).to_not be_valid
      end

      it 'accepts correctly formatted email' do
        contact.email = 'foo@bar'
        expect(contact).to be_valid
      end
    end
  end
end
