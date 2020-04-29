class Payment < ApplicationRecord
    enum payment_status:[:reserved, :confirmed, :missed, :completed, :cancelled, :reschedule]
    has_many :payment_histories
end
