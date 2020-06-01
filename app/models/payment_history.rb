class PaymentHistory < ApplicationRecord
    has_one_attached :upload_document

    enum payment_mode_id:[:auto, :manual]
end
