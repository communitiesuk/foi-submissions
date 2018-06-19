class AddReferenceToPublishedRequests < ActiveRecord::Migration[5.2]
  def change
    add_column :published_requests, :reference, :string
  end
end
