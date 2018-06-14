# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoiRequest, type: :model do
  let(:request) { build_stubbed(:foi_request) }

  describe 'associations' do
    it 'belongs to a contact' do
      expect(request.build_contact).to be_a Contact
    end

    it 'belongs to a submission' do
      expect(request.build_submission).to be_a Submission
    end

    it 'has many FOI suggestions' do
      expect(request.foi_suggestions.new).to be_a FoiSuggestion
    end

    it 'removes Contact on destroy' do
      request = create(:foi_request)
      expect { request.destroy }.to change { Contact.count }.by(-1)
    end

    it 'does not remove Submission on destroy' do
      request = create(:foi_request, :unqueued)
      expect(Submission.count).to eq 1
      expect { request.destroy }.to_not(change { Submission.count })
    end

    it 'does not remove FOI suggestions on destroy' do
      request = create(:foi_request_with_suggestions)
      expect(FoiSuggestion.count).to eq 3
      expect { request.destroy }.to_not(change { FoiSuggestion.count })
    end
  end

  describe 'attributes' do
    it 'requires an body' do
      request.body = nil
      expect(request.valid?).to eq false
      expect(request.errors[:body]).to_not be_empty
    end
  end

  describe 'scopes' do
    let!(:pending) { create(:foi_request) }
    let!(:unqueued) { create(:foi_request, :unqueued) }
    let!(:queued) { create(:foi_request, :queued) }
    let!(:delivered) { create(:foi_request, :delivered) }

    describe '.editable' do
      subject { FoiRequest.editable }
      it { is_expected.to match_array [pending, unqueued] }
    end

    describe '.sent' do
      subject { FoiRequest.sent }
      it { is_expected.to match_array [queued, delivered] }
    end

    describe '.delivered' do
      subject { FoiRequest.delivered }
      it { is_expected.to match_array [delivered] }
    end

    describe '.last_updated' do
      subject { FoiRequest.last_updated(2.seconds.ago) }

      it 'includes requests updated_at before given time' do
        _newer_request = create(:foi_request, updated_at: 1.second.ago)
        older_request = create(:foi_request, updated_at: 3.seconds.ago)
        is_expected.to match_array [older_request]
      end
    end

    describe '.removable' do
      subject { FoiRequest.removable }

      it 'includes requests pending/unqueued over 4 weeks ago' do
        _newer_pending = create(:foi_request,
                                updated_at: 4.weeks.ago + 1.minute)
        pending = create(:foi_request, updated_at: 4.weeks.ago)
        _newer_unqueued = create(:foi_request, :unqueued,
                                 updated_at: 4.weeks.ago + 1.minute)
        unqueued = create(:foi_request, :unqueued, updated_at: 4.weeks.ago)
        is_expected.to match_array [pending, unqueued]
      end

      it 'includes requests delivered over 1 week ago' do
        _newer_delivered = create(:foi_request, :delivered,
                                  updated_at: 1.week.ago + 1.minute)
        delivered = create(:foi_request, :delivered, updated_at: 1.week.ago)
        is_expected.to match_array [delivered]
      end

      it 'does not include any queued requests' do
        queued = create(:foi_request, :queued, updated_at: 1.year.ago)
        is_expected.to_not include queued
      end
    end
  end
end
