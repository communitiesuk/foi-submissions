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
  def convert_to_csv(object)
    object.csv_columns.map { |column| object.public_send(column) }
  end

  csv_string = CSV.generate do |csv|
    headers = objects.first&.csv_columns
    csv << headers if headers
    objects.each { |object| csv << convert_to_csv(object) }
  end

  send_data csv_string, type: Mime[:csv], filename: 'export.csv'
end
