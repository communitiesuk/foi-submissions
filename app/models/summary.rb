# frozen_string_literal: true

##
# Value object for PublishedRequest and CuratedLink summary attributes
#
class Summary < SimpleDelegator
  include ActionView::Helpers::SanitizeHelper

  def clean
    strip_tags(CGI.unescapeHTML(gsub('\r\n', "\r\n").squish))
  end
end
