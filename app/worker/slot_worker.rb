class SlotWorker
    include Sidekiq::Worker

    def perform booking_id
        booking = Booking.find booking_id

        #IF BOOKING STILL UNPAID RELEASE SLOT
        if booking.payment.payment_status == 0
            _allocation = booking.slot.allocations + 1
            slot.update status:0,allocations:_allocation;
        end
    end
end