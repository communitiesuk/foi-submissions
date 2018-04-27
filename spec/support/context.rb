# frozen_string_literal: true

RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context 'FOI Request Scope', shared_context: :metadata do
  let(:foi_request_scope) { double(:foi_request_scope) }

  before do
    allow(FoiRequest).to receive(:unqueued).
      and_return(foi_request_scope)
    allow(FoiRequest).to receive(:queued).
      and_return(foi_request_scope)

    allow(foi_request_scope).to receive(:includes).
      with(:contact).and_return(foi_request_scope)
    allow(foi_request_scope).to receive(:references).
      with(:contact).and_return(foi_request_scope)
  end
end
