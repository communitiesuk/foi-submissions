# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverSubmission, type: :service do
  let(:contact) { build(:contact, full_name: 'Worf', email: 'worf@ufp') }
  let(:foi_request) do
    build(:foi_request, :queued, contact: contact, body: 'A FOI request')
  end
  let(:submission) { foi_request.submission }
  let(:response) { Infreemation::Request.new(ref: '001') }
  let(:attributes) do
    {
      type: 'FOI',
      requester: 'Worf',
      contact: 'worf@ufp',
      contacttype: 'email',
      body: 'A FOI request'
    }
  end

  subject(:service) { described_class.new(submission) }

  describe '#call' do
    context 'successful response' do
      before do
        allow(Infreemation::Request).to receive(:create!).with(attributes).
          and_return(response)
      end

      it 'changes the state to delivered' do
        expect { service.call }.to change(submission, :state).
          to(Submission::DELIVERED)
      end

      it 'sets the reference' do
        expect { service.call }.to change(submission, :reference).
          from(nil).to('001')
      end

      it 'persists the change' do
        expect { service.call }.to change(submission, :persisted?).
          to(true)
      end
    end

    context 'unsuccessful response' do
      before do
        allow(Infreemation::Request).to receive(:create!).with(attributes).
          and_raise(Infreemation::GenericError)
      end

      it 'does not capture the exception' do
        expect { service.call }.to raise_error(Infreemation::GenericError)
      end
    end
  end
end
