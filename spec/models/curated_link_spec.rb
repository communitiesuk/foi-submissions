# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CuratedLink, type: :model do
  let(:curated_link) { build_stubbed(:curated_link) }

  describe 'attributes' do
    it 'requires a title' do
      curated_link.title = nil
      expect(curated_link.valid?).to eq false
      expect(curated_link.errors[:title]).to_not be_empty
    end

    it 'requires a url' do
      curated_link.url = nil
      expect(curated_link.valid?).to eq false
      expect(curated_link.errors[:url]).to_not be_empty
    end
  end

  describe '#keywords' do
    subject { curated_link.keywords }

    context 'when there are keywords' do
      let(:curated_link) do
        build_stubbed(:curated_link, keywords: 'budget health')
      end

      it 'splits on spaces' do
        is_expected.to eq(%w[budget health])
      end
    end

    context 'when there are no keywords' do
      let(:curated_link) do
        build_stubbed(:curated_link, keywords: nil)
      end

      it 'returns an empty Array' do
        is_expected.to eq([])
      end
    end
  end
end
