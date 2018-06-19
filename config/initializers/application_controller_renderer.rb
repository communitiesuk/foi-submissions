# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end

require 'csv'

ActionController::Renderers.add :csv do |objects, _options|
  klass = objects.first&.class
  unless klass.respond_to?(:csv_columns)
    raise StandardError, "#{klass} class doesn't respond to `csv_columns`"
  end

  def convert_to_csv(object)
    object.class.csv_columns.map do |column|
      value = object.public_send(column)
      case value
      when Time then value.to_s(:db)
      else value
      end
    end
  end

  csv_string = CSV.generate do |csv|
    headers = klass.csv_columns
    csv << headers if headers
    objects.each { |object| csv << convert_to_csv(object) }
  end

  send_data csv_string, type: Mime[:csv], filename: 'export.csv'
end
