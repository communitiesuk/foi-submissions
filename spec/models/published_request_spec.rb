# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishedRequest, type: :model do
  describe '.create_or_update_from_api!' do
    subject { described_class.create_or_update_from_api!(attributes) }

    context 'when a record with the ref does not exist' do
      let(:attributes) { attributes_for(:published_request)[:payload] }

      it 'persists the record' do
        expect { subject }.to change { described_class.count }.by(1)
      end
    end

    context 'when a record with the ref exists and attributes have changed' do
      let(:attributes) { attributes_for(:published_request)[:payload] }

      let!(:published_request) do
        old_attrs =
          attributes.merge(dateclosed: '1918-04-22', keywords: 'old')

        create(:published_request, payload: old_attrs)
      end

      it 'does not create a new record' do
        expect { subject }.not_to(change { described_class.count })
      end

      it 'updates the payload' do
        subject
        expect(published_request.reload.payload['keywords']).
          to eq('Business, business rates')
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
      expected = <<-TEXT.strip_heredoc.chomp
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
