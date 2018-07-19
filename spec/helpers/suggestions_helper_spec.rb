# frozen_string_literal: true

require 'rails_helper'

RSpec.describe SuggestionsHelper, type: :helper do
  include SuggestionsHelper

  describe '#format_summary' do
    it 'truncates text to 175 chars' do
      input = 'x' * 200
      expect(format_summary(input).length).to eq(175)
    end

    it 'truncates with an elipses' do
      input = 'x' * 200
      expect(format_summary(input).last).to eq('…')
    end

    it 'separates at a natural break' do
      # Otherwise you get 'word SPACE ...'
      input = 'x ' * 200
      expect(format_summary(input)).not_to match(/\s…\z/)
    end
  end
end
