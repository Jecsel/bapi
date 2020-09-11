class AddS3ArtifactToPaymentHistory < ActiveRecord::Migration[6.0]
  def change
    add_column :payment_histories, :s3_artifact, :string
    add_column :payments, :s3_artifact, :string
  end
end
