# frozen_string_literal: true

##
# This worker imports published requests from the disclosure log
#
class ImportDisclosureLogWorker
  include Sidekiq::Worker

  def perform(duration = nil)
    @duration = duration
    DisclosureLog.new(arguments).import!
  end

  private

  def arguments
    { start_date: start_date }.compact
  end

  def start_date
    case @duration
    when 'week' then Time.zone.today - 1.week
    when 'month' then Time.zone.today - 1.month
    when 'year' then Time.zone.today - 1.year
    when 'all' then Date.new(1970, 1, 1)
    end
  end
end
