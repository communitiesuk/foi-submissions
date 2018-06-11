# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CuratedLink, type: :model do
  let(:curated_link) { build_stubbed(:curated_link) }

  describe 'associations' do
    it 'has many FOI suggestions' do
      expect(curated_link.foi_suggestions.new).to be_a FoiSuggestion
    end

    it 'removes FOI suggestions on destroy' do
      curated_link = create(:curated_link_with_suggestions)
      expect { curated_link.destroy }.to change(FoiSuggestion, :count).
        from(3).to(0)
    end
  end

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
end
