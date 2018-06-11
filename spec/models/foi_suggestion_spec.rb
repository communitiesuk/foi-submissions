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
end
