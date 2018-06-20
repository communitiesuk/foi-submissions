# frozen_string_literal: true

require 'csv'

##
# Class to help with exporting data as CSV
#
class CSVExporter
  attr_reader :objects

  Error = Class.new(ArgumentError)

  def initialize(objects, _options = nil)
    @objects = objects
    return if objects&.empty?

    raise Error, "#{klass} doesn't respond to `csv_columns`" unless
      klass.respond_to?(:csv_columns)
  end

  def data
    CSV.generate do |csv|
      csv << headers unless headers.empty?
      objects.each { |object| csv << convert_to_csv(object) }
    end
  end

  private

  def klass
    @klass ||= objects&.first&.class
  end

  def headers
    @headers ||= klass&.csv_columns || []
  end

  def convert_to_csv(object)
    object.class.csv_columns.map do |column|
      map_value(object.public_send(column))
    end
  end

  def map_value(value)
    case value
    when Time then value.to_s(:db)
    else value
    end
  end
end
