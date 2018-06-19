class CreatePublishedRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :published_requests do |t|
      t.jsonb :payload

      t.timestamps
    end
  end
end
