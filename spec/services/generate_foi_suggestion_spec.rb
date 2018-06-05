# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateFoiSuggestion, type: :service do
  describe '.from_request' do
    def suggest(body)
      request = create(:foi_request, body: body)
      described_class.from_request(request)
    end

    let!(:l1) { create(:curated_link, keywords: 'housing, budget') }
    let!(:l2) { create(:curated_link, keywords: 'council tax') }

    it 'returns the matched selections' do
      s = suggest('What is the budget for housing in 2018?')
      expect(s).to match [l1]

      matches = s.first.request_matches
      expect(matches).to match_array %w[housing budget]
    end

    it 'returns an empty array when there are no matches' do
      s = suggest('What are the school admissions polices?')
      expect(s).to be_empty
    end

    it 'return matches using stemming and ignoring punctuation' do
      s1 = suggest('House')
      s2 = suggest('Houses')
      s3 = suggest('Housed')
      s4 = suggest('Housing')
      s5 = suggest('House\'s')

      expect(s1).to match [l1]
      expect(s2).to match [l1]
      expect(s3).to match [l1]
      expect(s4).to match [l1]
      expect(s5).to match [l1]

      matches1 = s1.first.request_matches
      matches2 = s2.first.request_matches
      matches3 = s3.first.request_matches
      matches4 = s4.first.request_matches
      matches5 = s5.first.request_matches

      expect(matches1).to match %w[house]
      expect(matches2).to match %w[houses]
      expect(matches3).to match %w[housed]
      expect(matches4).to match %w[housing]
      expect(matches5).to match %w[house]
    end

    it 'return ranked array when keywords separated by commas' do
      s1 = suggest('Give me information on housing budget?')
      s2 = suggest('Give me houses in my area?')
      expect(s1).to match [l1]
      expect(s2).to match [l1]

      rel1 = s1.first.relevance
      rel2 = s2.first.relevance
      expect(rel1).to be > rel2

      matches1 = s1.first.request_matches
      matches2 = s2.first.request_matches
      expect(matches1).to match_array %w[housing budget]
      expect(matches2).to match_array %w[houses]
    end

    it 'return ranked array when keywords separated by spaces' do
      s1 = suggest('What are the council tax bands?')
      s2 = suggest('How is my tax spent?')
      expect(s1).to match [l2]
      expect(s2).to match [l2]

      rel1 = s1.first.relevance
      rel2 = s2.first.relevance
      expect(rel1).to be > rel2

      matches1 = s1.first.request_matches
      matches2 = s2.first.request_matches
      expect(matches1).to match_array %w[council tax]
      expect(matches2).to match_array %w[tax]
    end

    it 'returns matches to more than one keyword' do
      s1 = suggest('Council budget')
      s2 = suggest('Tax budget')
      s3 = suggest('Council tax budget')

      expect(s1).to match [l1, l2]
      expect(s2).to match [l1, l2]
      expect(s3).to match [l2, l1]
    end
  end
end
