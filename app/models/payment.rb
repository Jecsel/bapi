class Payment < ApplicationRecord
    enum payment_status:[:reserved, :confirmed, :missed, :completed, :cancelled]
    has_many :payment_histories
end
