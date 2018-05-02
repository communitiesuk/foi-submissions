# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverSubmission, type: :service do
  let(:submission) { build(:submission) }
  subject(:service) { described_class.new(submission) }

  describe '#call' do
    it 'changes the state to queued' do
      expect { service.call }.to change(submission, :state).
        to(Submission::DELIVERED)
    end

    it 'sets the reference' do
      expect { service.call }.to change(submission, :reference).
        from(nil)
    end

    it 'persists the change' do
      expect { service.call }.to change(submission, :persisted?).
        to(true)
    end
  end
end
