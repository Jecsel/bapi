class CreateCampaignParticipants < ActiveRecord::Migration[6.0]
  def change
    create_table :campaign_participants do |t|
      t.references :campaign, null: false, foreign_key: true
      t.references :participant, null: false, foreign_key: true
      t.boolean :status, :default => true

      t.timestamps
    end
  end
end
