# frozen_string_literal: true

module ApplicationHelper # :nodoc:
  def link_to_suggestion(suggestion)
    if controller.is_a?(AdminController)
      suggestion.url
    else
      link_path(suggestion)
    end
  end
end
