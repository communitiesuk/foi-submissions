class AddKeywordsToCuratedLinks < ActiveRecord::Migration[5.2]
  def change
    add_column :curated_links, :keywords, :string
  end
end
