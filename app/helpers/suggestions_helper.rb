# frozen_string_literal: true

##
# Helper for the public view of FOI Request Suggestions
#
module SuggestionsHelper
  def format_summary(summary)
    cleaned = strip_tags(CGI.unescapeHTML(summary.gsub('\r\n', "\r\n").squish))
    truncate(cleaned, length: 175, omission: '…', separator: ' ')
  end
end
