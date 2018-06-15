# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishedRequest, type: :model do
  describe '#save' do
    let(:published_request) { build(:published_request) }

    before do
      published_request.save!
      published_request.reload
    end

    it 'creates a cache of the reference' do
      expect(published_request.reference).to eq('FOI-1')
    end

    it 'creates a cache of the keywords' do
      expect(published_request.keywords).to eq('Business, business rates')
    end

    it 'creates a cache of the url' do
      url = 'http://foi.infreemation.co.uk/redirect/hackney?id=1'
      expect(published_request.url).to eq(url)
    end

    it 'creates a cache of the subject as title' do
      expect(published_request.title).to eq('Business Rates')
    end

    it 'constructs a cache of the summary' do
      # Munge all responses in to one field for searching
      expected = <<-TEXT.strip_heredoc.chomp
      Initial FOI Request
      Dear Redacted
      Automated acknowledgement.
      Dear Redacted
      FOI Response
      Thank you for your help
      TEXT
      expect(published_request.summary).to eq(expected)
    end
  end
end
