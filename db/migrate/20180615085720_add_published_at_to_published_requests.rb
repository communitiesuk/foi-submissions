class AddPublishedAtToPublishedRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :published_requests, :published_at, :timestamp
  end
end
