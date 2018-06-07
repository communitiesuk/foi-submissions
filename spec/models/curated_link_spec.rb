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

  describe 'scopes' do
    let!(:active) { create(:curated_link, destroyed_at: nil) }
    let!(:destroyed) { create(:curated_link, destroyed_at: Time.zone.now) }

    describe '.active' do
      subject { described_class.active }
      it { is_expected.to match_array [active] }
    end
  end

  describe '#soft_destroy' do
    let(:curated_link) { create(:curated_link) }

    it 'updates destroyed_at with the current time' do
      freeze_time do
        expect { curated_link.soft_destroy }.
          to change { curated_link.destroyed_at }.from(nil).to(Time.zone.now)
      end
    end
  end
end
