class AddDestroyedAtToCuratedLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :curated_links, :destroyed_at, :datetime
  end
end
