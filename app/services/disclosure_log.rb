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

  def import!
    current_refs = PublishedRequest.
                   where('api_created_at >= ?', start_date).
                   pluck(:reference)
    imported_refs = import.pluck(:reference)
    expired_refs = current_refs - imported_refs
    PublishedRequest.where(reference: expired_refs).destroy_all
  end

  def import
    Infreemation::Request.where(query_params).map do |request|
      PublishedRequest.create_update_or_destroy_from_api!(request.attributes)
    end
  end

  private

  def query_params
    { rt: 'published', startdate: start_date, enddate: end_date }
  end
end
