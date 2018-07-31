# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Summary, type: :model do
  describe '#clean' do
    it 'replaces carriage returns with a space' do
      input = "Some\r\ntext\r\nfrom\r\nDOS.\r\n"
      expect(described_class.new(input).clean).to eq('Some text from DOS.')
    end

    it 'replaces false carriage returns with a space' do
      input = 'Some\r\ntext\r\nfrom\r\nDOS.\r\n'
      expect(described_class.new(input).clean).to eq('Some text from DOS.')
    end

    it 'strips tags from encoded HTML' do
      input = '&lt;p&gt;Hello&lt;/p&gt;'
      expect(described_class.new(input).clean).to eq('Hello')
    end

    it 'strips tags from decoded HTML' do
      input = '<p>Hello</p>'
      expect(described_class.new(input).clean).to eq('Hello')
    end

    it 'strips HTML attributes' do
      input = '&lt;p style=&quot;\color:rgb(1, 1, 1)&quot;\&gt;Blah&lt;/p&gt;'
      expect(described_class.new(input).clean).to eq('Blah')
    end
  end
end
