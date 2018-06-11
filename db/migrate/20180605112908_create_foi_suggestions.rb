class CreateFoiSuggestions < ActiveRecord::Migration[5.2]
  def change
    create_table :foi_suggestions do |t|
      t.references :foi_request
      t.references :resource, polymorphic: true
      t.string :request_matches
      t.decimal :relevance, precision: 7, scale: 6
      t.integer :clicks, default: 0, null: false
      t.integer :submissions, default: 0, null: false

      t.timestamps
    end
  end
end
