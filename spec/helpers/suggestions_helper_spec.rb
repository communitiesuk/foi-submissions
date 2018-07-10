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

    it 'replaces carriage returns with a space' do
      input = "Some\r\ntext\r\nfrom\r\nDOS.\r\n"
      expect(format_summary(input)).to eq('Some text from DOS.')
    end

    it 'replaces false carriage returns with a space' do
      input = 'Some\r\ntext\r\nfrom\r\nDOS.\r\n'
      expect(format_summary(input)).to eq('Some text from DOS.')
    end

    it 'strips tags from encoded HTML' do
      input = '&lt;p&gt;Hello&lt;/p&gt;'
      expect(format_summary(input)).to eq('Hello')
    end

    it 'strips tags from decoded HTML' do
      input = '<p>Hello</p>'
      expect(format_summary(input)).to eq('Hello')
    end

    it 'strips HTML attributes' do
      input = '&lt;p style=&quot;\color:rgb(1, 1, 1)&quot;\&gt;Blah&lt;/p&gt;'
      expect(format_summary(input)).to eq('Blah')
    end
  end
end
