class CreateFoiRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :foi_requests do |t|
      t.text :body, null: false
      t.references :contact, foreign_key: true
      t.references :submission, foreign_key: true

      t.timestamps
    end
  end
end
