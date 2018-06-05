# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoiSuggestion, type: :model do
  let(:suggestion) { build_stubbed(:foi_suggestion) }

  describe 'associations' do
    it 'belongs to a FOI request' do
      expect(suggestion.build_foi_request).to be_a FoiRequest
    end

    it 'belongs to a polymorphic resource' do
      expect(suggestion.resource).to be_a CuratedLink
      expect(suggestion.resource_id).to be_a Numeric
      expect(suggestion.resource_type).to eq 'CuratedLink'
    end

    it 'does not remove FOI request on destroy' do
      suggestion = create(:foi_suggestion)
      expect(FoiRequest.count).to eq 1
      expect { suggestion.destroy }.to_not(change { FoiRequest.count })
    end

    it 'does not remove resource on destroy' do
      suggestion = create(:foi_suggestion)
      expect(CuratedLink.count).to eq 1
      expect { suggestion.destroy }.to_not(change { CuratedLink.count })
    end
  end

  describe 'delegated methods' do
    let(:resource) do
      build(:curated_link, title: 'The title', url: 'http://example.com/abc',
                           summary: 'The summary', keywords: 'foo, bar, baz')
    end

    before { suggestion.resource = resource }

    describe '#title' do
      subject { suggestion.title }
      it { is_expected.to eq 'The title' }
    end

    describe '#url' do
      subject { suggestion.url }
      it { is_expected.to eq 'http://example.com/abc' }
    end

    describe '#summary' do
      subject { suggestion.summary }
      it { is_expected.to eq 'The summary' }
    end

    describe '#keywords' do
      subject { suggestion.keywords }
      it { is_expected.to eq 'foo, bar, baz' }
    end
  end

  describe '.from_request' do
    it 'delegates to GenerateFoiSuggestion service' do
      request = double(:request)
      expect(GenerateFoiSuggestion).to receive(:from_request).with(request)
      described_class.from_request(request)
    end
  end

  describe '.submitted!' do
    it 'calls submitted! on all instances' do
      suggestion = create(:foi_suggestion)
      expect { described_class.submitted! }.to(change do
        suggestion.reload
        suggestion.submissions
      end.by(1))
    end
  end

  describe '#submitted!' do
    it 'increases submissions count' do
      suggestion = create(:foi_suggestion)
      expect { suggestion.submitted! }.to change(suggestion, :submissions).by(1)
    end
  end

  describe '#clicked!' do
    it 'increases clicks count' do
      suggestion = create(:foi_suggestion)
      expect { suggestion.clicked! }.to change(suggestion, :clicks).by(1)
    end
  end
end
