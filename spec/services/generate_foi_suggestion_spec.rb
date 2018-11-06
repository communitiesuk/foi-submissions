# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GenerateFoiSuggestion, type: :service do
  describe '.from_request' do
    def suggest_all(body = nil, request: nil)
      request ||= create(:foi_request, body: body)
      described_class.from_request(request)
    end

    def suggest(*args)
      suggest_all(*args).first
    end

    context 'resources with keywords' do
      let!(:l1) { create(:curated_link, keywords: 'housing, budget') }
      let!(:l2) { create(:curated_link, keywords: 'council tax') }
      let!(:l3) do
        create(:curated_link, destroyed_at: Time.zone.now,
                              keywords: 'council tax')
      end

      it 'finds and updates existing suggestions' do
        suggestion = create(:foi_suggestion, resource: l1)
        request = suggestion.foi_request
        request.update(body: 'Housing budget')

        expect(suggest(request: request)).to eq suggestion
        expect { suggestion.reload }.to change(suggestion, :relevance)
      end

      it 'initialise new suggestions' do
        expect { suggest_all('Council budget') }.to(
          change(FoiSuggestion, :count).by(2)
        )
      end

      it 'returns the matched selections' do
        s = suggest('What is the budget for housing in 2018?')
        expect(s.resource).to eq l1

        matches = s.request_matches
        expect(matches).to eq 'budget, housing'
      end

      it 'returns an empty array when there are no matches' do
        s = suggest_all('What are the school admissions polices?')
        expect(s).to be_empty
      end

      it 'return matches using stemming and ignoring punctuation' do
        s1 = suggest('House')
        s2 = suggest('Houses')
        s3 = suggest('Housed')
        s4 = suggest('Housing')
        s5 = suggest('House\'s')

        expect(s1.resource).to eq l1
        expect(s2.resource).to eq l1
        expect(s3.resource).to eq l1
        expect(s4.resource).to eq l1
        expect(s5.resource).to eq l1

        matches1 = s1.request_matches
        matches2 = s2.request_matches
        matches3 = s3.request_matches
        matches4 = s4.request_matches
        matches5 = s5.request_matches

        expect(matches1).to eq 'house'
        expect(matches2).to eq 'houses'
        expect(matches3).to eq 'housed'
        expect(matches4).to eq 'housing'
        expect(matches5).to eq 'house'
      end

      it 'return ranked array when keywords separated by commas' do
        s1 = suggest('Give me information on housing budget?')
        s2 = suggest('Give me houses in my area?')
        expect(s1.resource).to eq l1
        expect(s2.resource).to eq l1

        rel1 = s1.relevance
        rel2 = s2.relevance
        expect(rel1).to be > rel2

        matches1 = s1.request_matches
        matches2 = s2.request_matches
        expect(matches1).to eq 'budget, housing'
        expect(matches2).to eq 'houses'
      end

      it 'return ranked array when keywords separated by spaces' do
        s1 = suggest('What are the council tax bands?')
        s2 = suggest('How is my tax spent?')
        expect(s1.resource).to eq l2
        expect(s2.resource).to eq l2

        rel1 = s1.relevance
        rel2 = s2.relevance
        expect(rel1).to be > rel2

        matches1 = s1.request_matches
        matches2 = s2.request_matches
        expect(matches1).to eq 'council, tax'
        expect(matches2).to eq 'tax'
      end

      it 'returns matches to more than one keyword' do
        s1 = suggest_all('Council budget').map(&:resource)
        s2 = suggest_all('Tax budget').map(&:resource)
        s3 = suggest_all('Council tax budget').map(&:resource)

        expect(s1).to match [l1, l2]
        expect(s2).to match [l1, l2]
        expect(s3).to match [l2, l1]
      end
    end

    context 'resource with AND boolean operator in keyword' do
      let!(:link) { create(:curated_link, keywords: 'teacher & support staff') }

      it 'returns matches to keywords' do
        s1 = suggest('teacher')
        s2 = suggest('teacher & support staff')
        s3 = suggest('support staff')

        expect(s1.resource).to eq link
        expect(s2.resource).to eq link
        expect(s3.resource).to eq link
      end
    end

    context 'resource with OR boolean operator in keyword' do
      let!(:link) { create(:curated_link, keywords: 'foo | bar') }

      it 'returns matches to keywords' do
        s1 = suggest('foo')
        expect(s1.resource).to eq link

        s2 = suggest('bar')
        expect(s2.resource).to eq link
      end
    end

    context 'resource with NOT boolean operator in keyword' do
      let!(:link) { create(:curated_link, keywords: '! baz') }

      it 'returns matches to keywords' do
        # This spec is here to check the query isn't broken.
        # We're expecting the resource to match the link due to how ts_highlight
        # works. It will highlights any matching part of the input string,
        # including those for NOT operations. This means we can't support the
        # NOT operation with our current implementation.
        s1 = suggest('baz')
        expect(s1.resource).to eq link
      end
    end

    context 'resource without keywords' do
      before { create(:curated_link, keywords: '') }

      it 'returns no suggestions' do
        expect(suggest_all('Request about council budgets')).to eq []
      end
    end

    context 'where SQL search throws and error' do
      let(:error) { ActiveRecord::StatementInvalid }

      before do
        allow(Resource).to receive(:find_by_sql).and_raise(error)
      end

      it 'returns no suggestions' do
        expect(suggest_all('Request about council budgets')).to eq []
      end

      it 'notifies exception' do
        expect(ExceptionNotifier).to receive(:notify_exception).with(error)
        suggest('Request about council budgets')
      end
    end
  end
end
