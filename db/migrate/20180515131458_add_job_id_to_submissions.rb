class AddJobIdToSubmissions < ActiveRecord::Migration[5.2]
  def change
    add_column :submissions, :job_id, :string
  end
end
