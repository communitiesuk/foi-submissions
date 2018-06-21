# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisclosureLog, type: :service do
  let(:requests) do
    [Infreemation::Request.new(ref: 'FOI-1'),
     Infreemation::Request.new(ref: 'FOI-2')]
  end

  describe 'initialisation' do
    before { travel_to Time.utc(2018, 6, 18, 11, 30) }

    it 'accepts a start_date' do
      subject = described_class.new(start_date: Date.new(2018, 2, 1))
      expect(subject.start_date).to eq Date.new(2018, 2, 1)
    end

    it 'defaults start_date to beginning of year' do
      expect(subject.start_date).to eq Date.new(2018, 1, 1)
    end

    it 'accepts an end_date' do
      subject = described_class.new(end_date: Date.new(2018, 2, 1))
      expect(subject.end_date).to eq Date.new(2018, 2, 1)
    end

    it 'defaults end_date to today' do
      expect(subject.end_date).to eq Date.new(2018, 6, 18)
    end
  end

  describe '#import' do
    context 'successful response' do
      before do
        allow(Infreemation::Request).to receive(:where).and_return(requests)
      end

      it 'creates or update published requests' do
        requests.each do |request|
          expect(PublishedRequest).
            to receive(:create_or_update_from_api!).with(request.attributes)
        end

        subject.import
      end
    end

    context 'unsuccessful response' do
      before do
        allow(Infreemation::Request).to receive(:where).
          and_raise(Infreemation::GenericError)
      end

      it 'does not capture the exception' do
        expect { subject.import }.to raise_error(Infreemation::GenericError)
      end
    end
  end
end
