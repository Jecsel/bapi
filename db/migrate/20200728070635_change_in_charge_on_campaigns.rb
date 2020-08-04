class ChangeInChargeOnCampaigns < ActiveRecord::Migration[6.0]
  def change
    remove_column :campaigns, :in_charge, :integer
    add_column :campaigns, :in_charge_person_id, :integer, references: :in_charge_people
  end
end
