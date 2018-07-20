# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishedRequest, type: :model do
  let(:published_request) { build_stubbed(:published_request) }

  describe 'associations' do
    it 'has many FOI suggestions' do
      expect(published_request.foi_suggestions.new).to be_a FoiSuggestion
    end

    it 'removes FOI suggestions on destroy' do
      published_request = create(:published_request_with_suggestions)
      expect { published_request.destroy }.to change(FoiSuggestion, :count).
        from(3).to(0)
    end
  end

  describe '.create_update_or_destroy_from_api!' do
    subject { described_class.create_update_or_destroy_from_api!(attributes) }

    let(:record) do
      double = instance_double(described_class.to_s)
      allow(double).to receive(:assign_attributes)
      allow(double).to receive(:save_or_destroy!)
      double
    end

    let(:attributes) { attributes_for(:published_request)[:payload] }

    before do
      allow(described_class).
        to receive(:find_or_initialize_by).and_return(record)
    end

    it 'assigns the payload to the record' do
      expect(record).to receive(:assign_attributes).with(payload: attributes)
      subject
    end

    it 'attempts to save or destroy the record' do
      expect(record).to receive(:save_or_destroy!)
      subject
    end
  end

  describe '#save_or_destroy!' do
    let(:non_blank_datepublished) do
      attributes_for(:published_request)[:payload].
        merge(datepublished: '2018-01-01')
    end

    let(:blank_datepublished) do
      attributes_for(:published_request)[:payload].merge(datepublished: '')
    end

    let(:published_request) { build(:published_request) }

    context 'with a new record' do
      it 'persists the record when datepublished is not blank' do
        published_request.payload = non_blank_datepublished
        expect { published_request.save_or_destroy! }.
          to change { described_class.count }.by(1)
      end

      it 'does not persist the record when datepublished is blank' do
        published_request.payload = blank_datepublished
        expect { published_request.save_or_destroy! }.
          not_to(change { described_class.count })
      end
    end

    context 'with a persisted record' do
      before { published_request.save! }

      it 'updates the record when datepublished is not blank' do
        published_request.payload = non_blank_datepublished
        published_request.save_or_destroy!
        expect(published_request.saved_changes?).to eq(true)
      end

      it 'destroys the record when datepublished is blank' do
        published_request.payload = blank_datepublished
        expect { published_request.save_or_destroy! }.
          to change { described_class.count }.by(-1)
      end
    end
  end

  describe '#save' do
    let(:published_request) { build(:published_request) }

    before do
      published_request.save!
      published_request.reload
    end

    it 'creates a cache of the reference' do
      expect(published_request.reference).to eq('FOI-1')
    end

    it 'creates a cache of the keywords' do
      expect(published_request.keywords).to eq('Business, business rates')
    end

    it 'creates a cache of the url' do
      url = 'http://foi.infreemation.co.uk/redirect/hackney?id=1'
      expect(published_request.url).to eq(url)
    end

    it 'creates a cache of the subject as title' do
      expect(published_request.title).to eq('Business Rates')
    end

    it 'constructs a cache of the summary' do
      # Munge all responses in to one field for searching
      expected = <<-TEXT.strip_heredoc.chomp.squish
      Initial FOI Request
      Dear Redacted
      Automated acknowledgement.
      Dear Redacted
      FOI Response
      Thank you for your help
      TEXT
      expect(published_request.summary).to eq(expected)
    end
  end
end
