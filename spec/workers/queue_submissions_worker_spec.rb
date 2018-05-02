# frozen_string_literal: true

require 'rails_helper'

RSpec.describe QueueSubmissionsWorker, type: :worker do
  let(:submission) { double(:submission) }
  let(:submission_scope) { double(:submission_scope) }
  subject(:perform) { described_class.perform_async }

  before do
    allow(Submission).to receive(:queueable).and_return(submission_scope)
    allow(submission_scope).to receive(:find_each).and_yield(submission)
  end

  around { |example| Sidekiq::Testing.inline!(&example) }

  it 'calls #queue on each queueable submission' do
    expect(submission).to receive(:queue)
    perform
  end
end
