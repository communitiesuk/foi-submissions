class CreateResources < ActiveRecord::Migration[5.2]
  def change
    create_view :resources
  end
end
