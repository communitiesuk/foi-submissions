# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Performance, type: :model do
  let(:performance) { build_stubbed(:performance) }

  describe 'attributes' do
    it 'requires an percentage' do
      performance.percentage = nil
      expect(performance.valid?).to eq false
      expect(performance.errors[:percentage]).to_not be_empty
    end

    context 'checks the value of the percentage' do
      it 'rejects invalid percentage' do
        performance.percentage = 101
        expect(performance).to_not be_valid
        performance.percentage = -1
        expect(performance).to_not be_valid
      end

      it 'accepts correct percentage' do
        performance.percentage = 100
        expect(performance).to be_valid
        performance.percentage = 0
        expect(performance).to be_valid
      end
    end
  end
end
