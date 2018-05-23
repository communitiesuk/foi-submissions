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
end
