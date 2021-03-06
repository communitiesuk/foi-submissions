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

  describe '.csv_columns' do
    it 'returns an array' do
      expect(described_class.csv_columns).to be_a Array
    end
  end

  describe 'resource delegate methods' do
    before do
      resource.resource = CuratedLink.new(
        id: 3,
        created_at: Time.utc(2018, 1, 1, 0, 0),
        updated_at: Time.utc(2018, 1, 1, 0, 1)
      )
    end

    describe '#id' do
      subject { resource.id }
      it { is_expected.to eq 3 }
    end

    describe '#created_at' do
      subject { resource.created_at }
      it { is_expected.to eq Time.utc(2018, 1, 1, 0, 0) }
    end

    describe '#updated_at' do
      subject { resource.updated_at }
      it { is_expected.to eq Time.utc(2018, 1, 1, 0, 1) }
    end
  end

  describe 'statistics delegate methods' do
    before do
      expect(resource).to(
        receive_message_chain(:foi_suggestions, :statistics).
        and_return(shown: 3, click_rate: 0.66, answer_rate: 0.33)
      )
    end

    describe '#shown' do
      subject { resource.shown }
      it { is_expected.to eq 3 }
    end

    describe '#click_rate' do
      subject { resource.click_rate }
      it { is_expected.to eq 0.66 }
    end

    describe '#answer_rate' do
      subject { resource.answer_rate }
      it { is_expected.to eq 0.33 }
    end
  end

  describe '#type' do
    subject { resource.type }

    it 'titleise the resource_type' do
      resource.resource_type = 'FooBar_baz'
      is_expected.to eq 'Foo Bar Baz'
    end
  end
end
