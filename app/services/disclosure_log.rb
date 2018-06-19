# frozen_string_literal: true

##
# Creates a local cache of requests published in the disclosure log
#
class DisclosureLog
  attr_reader :start_date, :end_date

  def initialize(start_date: nil, end_date: nil)
    @start_date = start_date || Time.zone.today.beginning_of_year
    @end_date = end_date || Time.zone.today
  end

  def import
    Infreemation::Request.where(query_params).map do |request|
      PublishedRequest.create_or_update_from_api!(request.attributes)
    end
  end

  private

  def query_params
    { rt: 'published', startdate: start_date, enddate: end_date }
  end
end
