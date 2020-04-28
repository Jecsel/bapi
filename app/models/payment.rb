class Payment < ApplicationRecord
    enum payment_status:[:reserved, :confirmed, :missed, :completed, :cancelled]
end
