class AddApiCreatedAtToPublishedRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :published_requests, :api_created_at, :timestamp
  end
end
