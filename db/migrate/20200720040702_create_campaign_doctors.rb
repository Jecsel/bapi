class CreateCampaignDoctors < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_doctors do |t|
      t.string :code
      t.boolean :status

      t.timestamps
    end
  end
end
