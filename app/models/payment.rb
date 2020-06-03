class Payment < ApplicationRecord
    enum payment_status:[:reserved, :confirmed, :missed, :completed, :cancelled, :reschedule]
    enum payment_type:[:auto, :manual]
    has_many :payment_histories
end
