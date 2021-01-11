class BookingMailer < ApplicationMailer
    def itinerary booking_id
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        if @booking.clinic.present? 
            _bcc << @booking.clinic.email_address
        end
        attachments['confirmation_receipt.pdf'] = generate_pdf_content(booking_id)
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end
    def reservation booking_id
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        # if @booking.clinic.present? 
        #     _bcc << @booking.clinic.email_address
        # end
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Reservation | REF: #{@booking.reference_code}")
    end
    
    def manual_confirmation booking_id, reschedule
        @booking = Booking.find booking_id
        _bcc = ENV["CC_MAIL"].split("|")
        if @booking.clinic.present? 
            _bcc << @booking.clinic.email_address
        end
        attachments['confirmation_receipt.pdf'] = generate_pdf_content(booking_id) if !reschedule
        Setting.last.increment!(:receipt_count) 
        mail(
            to: @booking.payment.user_email, 
            bcc: _bcc,
            subject: "COVID-19 Drive-Thru Booking Confirmation  | REF: #{@booking.reference_code}")
    end

    private
    
    def generate_pdf_content booking_id
        pdf = ReceiptGenerator.new(booking_id).generate_booking_receipt
        Tempfile.create do |f|
          pdf.render_file f
          f.flush
          File.read(f)
        end
      end
end