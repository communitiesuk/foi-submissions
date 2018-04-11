class CreateSubmissions < ActiveRecord::Migration[5.2]
  def change
    create_table :submissions do |t|
      t.string :state, null: false

      t.timestamps
    end
  end
end
