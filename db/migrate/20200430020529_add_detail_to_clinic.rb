class AddDetailToClinic < ActiveRecord::Migration[6.0]
  def change
    add_column :clinics, :email_address, :string
    add_column :clinics, :contact_number, :string
    add_column :clinics, :address, :text
    add_column :clinics, :contact_person, :string
    add_column :clinics, :billing_code, :string
    add_column :clinics, :status, :boolean
  end
end
