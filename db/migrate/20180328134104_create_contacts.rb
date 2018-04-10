class CreateContacts < ActiveRecord::Migration[5.2]
  def change
    create_table :contacts do |t|
      t.string :full_name, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
