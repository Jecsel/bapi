class RemoveReferenceTypeToLocation < ActiveRecord::Migration[6.0]
  def change
    remove_column :locations, :referral_type, :integer
  end
end
