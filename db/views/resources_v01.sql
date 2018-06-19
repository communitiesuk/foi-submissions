SELECT
  id AS resource_id,
  'CuratedLink' AS resource_type,
  title, summary, url, keywords
FROM curated_links
WHERE destroyed_at IS NULL
UNION
SELECT
  id AS resource_id,
  'PublishedRequest' AS resource_type,
  title, summary, url, keywords
FROM published_requests
WHERE published_at IS NOT NULL
