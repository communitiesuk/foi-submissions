# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverSubmissionWorker, type: :worker do
  let(:submission) { build(:submission) }
  let(:submission_scope) { double(:submission_scope) }
  subject(:perform) { described_class.perform_async(1) }

  around { |example| Sidekiq::Testing.inline!(&example) }

  before do
    allow(Submission).to receive(:deliverable).
      and_return(submission_scope)
    allow(submission_scope).to receive(:find_by).
      and_return(submission)
  end

  context 'with a deliverable submission and when lockable' do
    it 'finds submission from ID' do
      expect(submission_scope).to receive(:find_by).with(id: 1).
        and_return(submission)
      perform
    end

    it 'calls #deliver on submission' do
      expect(submission).to receive(:deliver)
      perform
    end
  end

  context 'without a deliverable submission' do
    let(:submission) { nil }

    it 'does not raise any errors' do
      expect { perform }.to_not raise_error
    end
  end

  context 'when already locked' do
    let(:lock) { set_sidekiq_lock(described_class, 1) }

    before { lock.acquire! }
    after { lock.release! }

    it 'does not call #deliver on submission' do
      expect(submission).to_not receive(:deliver)
      perform
    end
  end

  context 'when another record is locked' do
    let(:lock) { set_sidekiq_lock(described_class, 2) }

    before { lock.acquire! }
    after { lock.release! }

    it 'call #deliver on submission' do
      expect(submission).to receive(:deliver)
      perform
    end
  end
end
