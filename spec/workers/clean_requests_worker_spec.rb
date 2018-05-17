# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CleanRequestsWorker, type: :worker do
  let(:request_scope) { double(:request_scope) }
  subject(:perform) { described_class.perform_async }

  before do
    allow(FoiRequest).to receive(:removable).and_return(request_scope)
  end

  around { |example| Sidekiq::Testing.inline!(&example) }

  it 'calls #destory_all on removable requests' do
    expect(request_scope).to receive(:destory_all)
    perform
  end
end
