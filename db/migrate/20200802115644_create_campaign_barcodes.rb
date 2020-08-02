class CreateCampaignBarcodes < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_barcodes do |t|
      t.references :campaign, null: false, foreign_key: true
      t.string :barcode

      t.timestamps
    end
  end
end
