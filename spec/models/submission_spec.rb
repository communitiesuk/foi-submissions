# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:submission) { build_stubbed(:submission) }

  describe 'assoications' do
    it 'has one FOI request' do
      expect(submission.build_foi_request).to be_a FoiRequest
    end

    it 'removes FOI request on destroy' do
      submission = create(:foi_request, :unqueued).submission
      expect { submission.destroy }.to change { FoiRequest.count }.by(-1)
    end
  end

  describe 'attributes' do
    it 'requires an state' do
      submission.state = nil
      expect(submission.valid?).to eq false
      expect(submission.errors[:state]).to_not be_empty
    end
  end

  describe 'scopes' do
    let!(:unqueued) { create(:submission, :unqueued) }
    let!(:queued) { create(:submission, :queued) }
    let!(:delivered) { create(:submission, :delivered, reference: nil) }
    let!(:delivered_successfully) { create(:submission, :delivered) }

    describe '.queueable' do
      subject { Submission.queueable }
      it { is_expected.to match_array [unqueued] }
    end

    describe '.deliverable' do
      subject { Submission.deliverable }
      it { is_expected.to match_array [queued] }
    end

    describe '.delivered' do
      subject { Submission.delivered }
      it { is_expected.to match_array [delivered, delivered_successfully] }
    end

    describe '.delivered_successfully' do
      subject { Submission.delivered_successfully }
      it { is_expected.to match_array [delivered_successfully] }
    end
  end

  describe '#queue' do
    it 'delegates to QueueSubmission service' do
      service = double(:service)
      expect(QueueSubmission).to receive(:new).with(submission).
        and_return(service)
      expect(service).to receive(:call)

      submission.queue
    end
  end

  describe '#deliverable?' do
    subject { submission.deliverable? }

    context 'in unqueued state' do
      before { submission.state = Submission::UNQUEUED }
      it { is_expected.to eq false }
    end

    context 'in queued state' do
      before { submission.state = Submission::QUEUED }
      it { is_expected.to eq true }
    end

    context 'in delivered state' do
      before { submission.state = Submission::DELIVERED }
      it { is_expected.to eq false }
    end
  end

  describe '#deliver' do
    it 'delegates to DeliverSubmission service' do
      service = double(:service)
      expect(DeliverSubmission).to receive(:new).with(submission).
        and_return(service)
      expect(service).to receive(:call)

      submission.deliver
    end
  end
end
