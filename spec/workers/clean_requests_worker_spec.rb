# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CleanRequestsWorker, type: :worker do
  subject(:perform) { described_class.perform_async }

  around { |example| Sidekiq::Testing.inline!(&example) }

  it 'calls #destroy_all on removable requests' do
    request_scope = double(:request_scope)
    allow(FoiRequest).to receive(:removable).and_return(request_scope)
    expect(request_scope).to receive(:destroy_all)
    perform
  end

  it 'removes old requests from the database' do
    request = create(:foi_request, updated_at: 1.year.ago)
    perform
    expect { request.reload }.to raise_error ActiveRecord::RecordNotFound
  end
end
