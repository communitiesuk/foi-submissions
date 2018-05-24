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
    before { allow(submission).to receive(:deliver) }

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

  describe 'locking' do
    let(:submission) { create(:submission, :queued) }

    it 'calls Submission#deliver with SQL locking' do
      # Update all records in the DB; this doesn't update the in memory Ruby
      # submission instance. This is simulating another worker running.
      Submission.update(state: Submission::DELIVERED)

      # Prove this in memory submission instance still has the old state:
      expect(submission.state).to eq Submission::QUEUED

      # Stub `Submission#deliver` as calling the original implementation isn't
      # any good as it would try create a remote request which is obviously
      # outside the concern for this test. Prove these methods are called:
      expect(submission).to receive(:deliver)
      expect(submission).to receive(:with_lock).and_call_original

      # Run the worker job.
      perform

      # Because of the `with_lock` block the submission instance gets reloaded.
      # Without this the state would have remained as QUEUED and saved into the
      # database. Prove submission has been reloaded and has the state from the
      # first step:
      expect(submission.state).to eq Submission::DELIVERED
    end
  end
end
