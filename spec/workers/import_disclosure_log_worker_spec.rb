# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ImportDisclosureLogWorker, type: :worker do
  let(:duration) { nil }
  subject(:perform) { described_class.perform_async(duration) }

  before { travel_to Time.utc(2018, 6, 18, 11, 30) }
  around { |example| Sidekiq::Testing.inline!(&example) }

  let(:log) { double(:disclosure_log) }

  context 'no duration' do
    it 'calls #import on DisclosureLog instance without duration' do
      expect(DisclosureLog).to receive(:new).with({}).and_return(log)
      expect(log).to receive(:import)
      perform
    end
  end

  context 'all duration' do
    let(:duration) { 'all' }

    it 'calls #import on DisclosureLog instance with start date 1970-01-01' do
      expect(DisclosureLog).to receive(:new).with(
        start_date: Date.new(1970, 1, 1)
      ).and_return(log)
      expect(log).to receive(:import)
      perform
    end
  end

  context 'year duration' do
    let(:duration) { 'year' }

    it 'calls #import on DisclosureLog instance with start date 1 year ago' do
      expect(DisclosureLog).to receive(:new).with(
        start_date: Date.new(2017, 6, 18)
      ).and_return(log)
      expect(log).to receive(:import)
      perform
    end
  end

  context 'month duration' do
    let(:duration) { 'month' }

    it 'calls #import on DisclosureLog instance with start date 1 month ago' do
      expect(DisclosureLog).to receive(:new).with(
        start_date: Date.new(2018, 5, 18)
      ).and_return(log)
      expect(log).to receive(:import)
      perform
    end
  end

  context 'week duration' do
    let(:duration) { 'week' }

    it 'calls #import on DisclosureLog instance with start date 1 week ago' do
      expect(DisclosureLog).to receive(:new).with(
        start_date: Date.new(2018, 6, 11)
      ).and_return(log)
      expect(log).to receive(:import)
      perform
    end
  end
end
