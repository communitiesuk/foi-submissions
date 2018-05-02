class AddReferenceToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :reference, :string
  end
end
