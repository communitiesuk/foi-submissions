class AddCacheColumnsToPublishedRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :published_requests, :title, :string
    add_column :published_requests, :url, :string
    add_column :published_requests, :summary, :text
    add_column :published_requests, :keywords, :string
  end
end
