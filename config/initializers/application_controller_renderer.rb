# frozen_string_literal: true

# Be sure to restart your server when you modify this file.

# ActiveSupport::Reloader.to_prepare do
#   ApplicationController.renderer.defaults.merge!(
#     http_host: 'example.org',
#     https: false
#   )
# end

ActionController::Renderers.add :csv do |objects, options|
  export = CSVExporter.new(objects, options)
  send_data export.data, type: Mime[:csv], filename: 'export.csv'
end
