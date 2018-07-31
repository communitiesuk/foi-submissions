# frozen_string_literal: true

##
# Helper for the public view of FOI Request Suggestions
#
module SuggestionsHelper
  def format_summary(summary)
    truncate(summary, length: 175, omission: '…', separator: ' ')
  end
end
