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

  describe '#import!' do
    before do
      travel_to(Time.utc(2018, 6, 18, 11, 30))
      allow(Infreemation::Request).to receive(:where).and_return(requests)
    end

    let(:requests) do
      request_attrs = [{ ref: 'FOI-2',
                         datepublished: '2018-06-17',
                         datecreated: '2018-06-17',
                         requestbody: '',
                         history: {} },
                       { ref: 'FOI-4',
                         datepublished: '',
                         datecreated: '2018-06-17',
                         requestbody: '',
                         history: {} }]

      request_attrs.map { |attrs| Infreemation::Request.new(attrs) }
    end

    # This request is outside the default start_date of 1 year ago
    # It is not returned by the feed
    let!(:published_request_1) do
      create(:published_request,
             payload: { ref: 'FOI-1',
                        datepublished: Time.zone.parse('2010-01-01'),
                        datecreated: Time.zone.parse('2010-01-01'),
                        subject: 's',
                        requestbody: 'b',
                        history: {} })
    end

    # This request is inside the window of results that we may expect
    # It is returned by the feed
    let!(:published_request_2) do
      create(:published_request,
             payload: { ref: 'FOI-2',
                        datepublished: Time.zone.parse('2018-06-17'),
                        datecreated: Time.zone.parse('2018-06-17'),
                        subject: 's',
                        requestbody: 'b',
                        history: {} })
    end

    # This request is inside the window of results that we may expect
    # It is not returned by the feed
    let!(:published_request_3) do
      create(:published_request,
             payload: { ref: 'FOI-3',
                        datepublished: Time.zone.parse('2018-06-17'),
                        datecreated: Time.zone.parse('2018-06-17'),
                        subject: 's',
                        requestbody: 'b',
                        history: {} })
    end

    # This request is inside the window of results that we may expect
    # It is returned by the feed
    # It has an empty datepublished so will be deleted
    let!(:published_request_4) do
      create(:published_request,
             payload: { ref: 'FOI-4',
                        datepublished: Time.zone.parse('2018-06-17'),
                        datecreated: Time.zone.parse('2018-06-17'),
                        subject: 's',
                        requestbody: 'b',
                        history: {} })
    end

    it 'keeps requests that are older than the start date param of the import' do
      subject.import!
      expect(published_request_1.reload).to be_persisted
    end

    it 'keeps requests inside the import window that are returned by the feed' do
      subject.import!
      expect(published_request_2.reload).to be_persisted
    end

    it 'destroys requests inside the import window that are not returned by the feed' do
      subject.import!
      expect { published_request_3.reload }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'destroys requests inside the import window that have a blank datepublished' do
      subject.import!
      expect { published_request_4.reload }.
        to raise_error(ActiveRecord::RecordNotFound)
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
            to receive(:create_update_or_destroy_from_api!).
            with(request.attributes)
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
