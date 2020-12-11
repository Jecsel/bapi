class AddAddressToPatient < ActiveRecord::Migration[6.0]
  def change
    add_column :patients, :line_1, :string
    add_column :patients, :line_2, :string
    add_column :patients, :post, :string
    add_column :patients, :state_id, :integer
    add_column :patients, :state_name, :string
  end
end
