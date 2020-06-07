class PaymentHistory < ApplicationRecord
    has_one_attached :upload_document
    belongs_to :payment_mode, optional:true
end
