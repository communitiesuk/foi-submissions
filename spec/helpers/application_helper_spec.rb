# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#link_to_suggestion' do
    let(:suggestion) do
      resource = build(:curated_link, url: 'http://example.com/dfg')
      build_stubbed(:foi_suggestion, id: 1, resource: resource)
    end

    subject { helper.link_to_suggestion(suggestion) }

    context 'admin controller' do
      before do
        allow(controller).to receive(:is_a?).with(AdminController).
          and_return(true)
      end

      it 'links directly to suggestion resource' do
        is_expected.to eq 'http://example.com/dfg'
      end
    end

    context 'other controller' do
      before do
        allow(controller).to receive(:is_a?).with(AdminController).
          and_return(false)
      end

      it 'links to links controller' do
        is_expected.to eq '/links/1'
      end
    end
  end
end
