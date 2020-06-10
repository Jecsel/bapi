class AlterReferenceTypeToLocation < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :referral_type, :integer, default:0
  end
end
