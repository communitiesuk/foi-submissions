# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:submission) { build_stubbed(:submission) }

  describe 'assoications' do
    it 'has one FOI request' do
      expect(submission.build_foi_request).to be_a FoiRequest
    end

    it 'removes FOI request on destroy' do
      submission = create(:foi_request).submission
      expect { submission.destroy }.to change { FoiRequest.count }.by(-1)
    end
  end

  describe 'attributes' do
    it 'requires an state' do
      submission.state = nil
      expect(submission.valid?).to eq false
      expect(submission.errors[:state]).to_not be_empty
    end
  end
end
