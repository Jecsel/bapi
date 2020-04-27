class Payment < ApplicationRecord
    has_many :payment_histories
end
