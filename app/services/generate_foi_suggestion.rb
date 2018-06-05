# frozen_string_literal: true

##
# Provides suggested resources based on the FOI request made by a user.
#
class GenerateFoiSuggestion
  def self.from_request(request)
    sql = <<~SQL
      SELECT request_matches, relevance, curated_links.*
      FROM curated_links,
      LATERAL (#{request_matches}) AS T1(request_matches),
      LATERAL (#{relevance}) AS T2(relevance)
      WHERE relevance > 0.5
      ORDER BY relevance DESC
      LIMIT 3
    SQL

    CuratedLink.find_by_sql([sql, request: request])
  end

  # Rank curated links on the request keyword matches against the title, summary
  # or keywords - with different weighting for each
  def self.relevance
    <<~SQL
      SELECT ts_rank(
        setweight(to_tsvector(title), 'B') ||
        setweight(to_tsvector(COALESCE(summary, '')), 'C') ||
        setweight(to_tsvector(keywords), 'A'),
        to_tsquery(array_to_string(request_matches, ' & '))
      )
    SQL
  end
  private_class_method :relevance

  # Aggregate matched keywords wrapped in a <b> tags into an array and giving us
  # an idea of the intent of the request
  def self.request_matches
    <<~SQL
      SELECT ARRAY_AGG(DISTINCT rm[1])
      FROM (#{request_headline}) AS T(headline)
      CROSS JOIN LATERAL regexp_matches(headline, '<b>(.*?)</b>', 'g') AS rm(matches)
    SQL
  end
  private_class_method :request_matches

  # Generate a headline string which wraps matching keywords in a <b> tag. This
  # includes keyword stems
  def self.request_headline
    <<~SQL
      SELECT ts_headline(LOWER(body), to_tsquery((#{keywords_query})))
      FROM foi_requests
      WHERE foi_requests.id = :request
      LIMIT 1
    SQL
  end
  private_class_method :request_headline

  # Build a query of keywords to be passed into to_tsquery using the OR operator
  # and the AND operator for two or more words together
  def self.keywords_query
    <<~SQL
      SELECT array_to_string(ARRAY_AGG(
        '(' || regexp_replace(keyword, '\s+', ' & ', 'g') || ')'
      ), ' | ')
      FROM (#{keywords}) AS T(keyword)
    SQL
  end
  private_class_method :keywords_query

  # Get a unique list of all comma separated keywords from current curated links
  def self.keywords
    <<~SQL
      SELECT DISTINCT UNNEST(regexp_split_to_array(keywords, ',\s*'))
      FROM curated_links _cl
      WHERE _cl.id = curated_links.id
    SQL
  end
  private_class_method :keywords
end
