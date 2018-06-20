# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CSVExporter, type: :service do
  Mock = Struct.new(:name, :time)
  class MockEvent < Mock
    def self.csv_columns
      %i[name time]
    end
  end

  let(:objects) { [MockEvent.new('event', Time.utc(2018, 6, 20, 15, 30))] }
  subject(:export) { described_class.new(objects) }

  describe 'initialisation' do
    it 'assigns objects' do
      expect(export.objects).to eq objects
    end

    it 'requires class which response to csv_columns' do
      expect { export }.to_not raise_error
      expect { described_class.new(['foo']) }.to raise_error(CSVExporter::Error)
    end

    it 'can handle no objects without raising an error' do
      expect { described_class.new([]) }.to_not raise_error
    end
  end

  describe '#data' do
    subject(:data) { export.data }
    let(:lines) { data.split("\n") }

    it 'generates valid CSV string' do
      expect { CSV.parse(data).inspect }.to_not raise_error
    end

    it 'includes CSV headers' do
      expect(lines.first).to eq 'name,time'
    end

    it 'maps Times to DB format' do
      expect(lines.last).to eq 'event,2018-06-20 15:30:00'
    end

    context 'without an objects' do
      let(:objects) { [] }
      it { is_expected.to eq '' }
    end
  end
end
