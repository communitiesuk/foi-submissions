# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoiSuggestion, type: :service do
  describe '.from_text' do
    it 'returns an empty array' do
      expect(described_class.from_text('An FOI request…')).to be_empty
    end
  end
end
