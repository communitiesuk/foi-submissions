# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QueueSubmission, type: :service do
  let(:submission) { build(:submission) }
  subject(:service) { described_class.new(submission) }

  describe '#call' do
    context 'Redis instance available' do
      it 'changes the state to queued' do
        expect { service.call }.to change(submission, :state).
          to(Submission::QUEUED)
      end

      it 'queues job' do
        expect { service.call }.to change(DeliverSubmissionWorker.jobs, :size).
          by(1)
      end

      it 'persists the change' do
        expect { service.call }.to change(submission, :persisted?).
          to(true)
      end

      it 'returns true' do
        expect(service.call).to eq true
      end
    end

    context 'Redis instance unavailable' do
      before do
        allow(DeliverSubmissionWorker).to receive(:perform_async).
          and_raise(Redis::BaseConnectionError)
      end

      it 'changes the state to unqueued' do
        expect { service.call }.to change(submission, :state).
          to(Submission::UNQUEUED)
      end

      it 'persists the change' do
        expect { service.call }.to change(submission, :persisted?).
          to(true)
      end

      it 'returns true' do
        expect(service.call).to eq true
      end
    end
  end
end
