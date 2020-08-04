class CreateCampaigns < ActiveRecord::Migration[6.0]
  def change
    create_table :campaigns do |t|
      t.string :event_name
      t.references :campaign_client, null: false, foreign_key: true
      t.references :campaign_company, null: false, foreign_key: true
      t.references :campaign_billing, null: false, foreign_key: true
      t.references :campaign_doctor, null: false, foreign_key: true
      t.string :campaign_site, :limit => 300
      t.date :campaign_start_date
      t.date :campaign_end_date
      t.time :campaign_start_time
      t.time :campaign_end_time
      t.string :package
      t.boolean :optional_test
      t.integer :est_pax
      t.boolean :need_phleb
      t.integer :no_of_phleb
      t.string :remarks, :limit => 300
      t.string :report_management, :limit => 300
      t.string :onsite_pic_name
      t.string :onsite_pic_contact
      t.integer :in_charge
      t.boolean :status

      t.timestamps
    end
  end
end
