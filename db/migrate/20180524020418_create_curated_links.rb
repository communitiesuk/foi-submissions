class CreateCuratedLinks < ActiveRecord::Migration[5.2]
  def change
    create_table :curated_links do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.text :summary

      t.timestamps
    end
  end
end
