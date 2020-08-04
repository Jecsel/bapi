class AddCreatedToCampaign < ActiveRecord::Migration[6.0]
  def change
    add_column :campaigns, :created_by, :string
    add_column :campaigns, :updated_by, :string
  end
end
