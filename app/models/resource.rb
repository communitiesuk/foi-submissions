# frozen_string_literal: true

##
# Union of CuratedLink and PublishedRequest powered by a Postgres view
#
class Resource < ApplicationRecord
  belongs_to :resource, polymorphic: true
end
