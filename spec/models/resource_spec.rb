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

  describe 'resource delegate methods' do
    before do
      resource.resource = CuratedLink.new(
        id: 3,
        created_at: Time.new(2018, 1, 1, 0, 0).utc,
        updated_at: Time.new(2018, 1, 1, 0, 1).utc
      )
    end

    describe '#id' do
      subject { resource.id }
      it { is_expected.to eq 3 }
    end

    describe '#created_at' do
      subject { resource.created_at }
      it { is_expected.to eq Time.new(2018, 1, 1, 0, 0).utc }
    end

    describe '#updated_at' do
      subject { resource.updated_at }
      it { is_expected.to eq Time.new(2018, 1, 1, 0, 1).utc }
    end
  end
end
