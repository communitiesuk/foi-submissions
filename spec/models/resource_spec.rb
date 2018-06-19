# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Resource, type: :model do
  let(:resource) { build_stubbed(:resource) }

  describe 'associations' do
    it 'belongs to a polymorphic resource' do
      expect(resource.resource).to be_a CuratedLink
      expect(resource.resource_id).to be_a Numeric
      expect(resource.resource_type).to eq 'CuratedLink'
    end
  end
end
