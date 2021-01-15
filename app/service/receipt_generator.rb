class ReceiptGenerator
    include Prawn::View

    attr_accessor   :booking

    def initialize booking_id
        @booking = Booking.find booking_id
        @document = Prawn::Document.new({template: "#{Rails.root}/public/templates/receipt_template.pdf"})
    end

    def generate_booking_receipt
        @document.text_box "Payment Receipt", :at => [0,680], :align => :center, :style => :bold

        @document.text_box "#{@booking.patient.fullname.titlecase}", :at => [0,660], :align => :left, :style => :bold
        @document.text_box "<b> NRIC: </b> #{@booking.patient.id_number.upcase}", :at => [0,645], :align => :left, :inline_format => true
        @document.text_box "<b> REF NO: </b> #{@booking.reference_code.upcase}", :at => [0,630], :align => :left, :inline_format => true
        @document.text_box "<b> Transaction ID: </b>#{@booking.payment.payment_histories.last.payment_reference}", :at => [0,615], :align => :left, :inline_format => true
        
        @document.text_box "RECEIPT NO", :at => [330,660], :style => :bold
        @document.text_box "RECEIPT DATE", :at => [330,645], :style => :bold
        @document.text_box "TERMS", :at => [330,630], :style => :bold

        @document.text_box ": ##{Time.current.year % 100}-#{sprintf '%08d', @booking.payment.amount}", :at => [430,660]
        @document.text_box ": #{Date.current.strftime("%d/%m/%Y")}", :at => [430,645]
        @document.text_box ": Transfer", :at => [430,630]


        @document.bounding_box([0,580], :width => bounds.width, :height=>100) do 
            stroke do
                stroke_horizontal_rule
                move_down 22
                stroke_horizontal_rule
            end 
        end
        @document.text_box "Particulars", :at => [30,575]
        @document.text_box "Unit Price", :at => [250,575]
        @document.text_box "Quantity", :at => [330,575]
        @document.text_box "RM", :at => [450,575]

        @document.text_box "Covid 19 Testing", :at => [0,545]
        @document.text_box "#{@booking.payment.amount}", :at => [250,545]
        @document.text_box "1", :at => [330,545]
        @document.text_box "#{@booking.payment.amount}", :at => [450,545]
        
        stroke do
            horizontal_line(290, 525, :at => 222)
            horizontal_line(290, 525, :at => 200)
        end 

        @document.text_box "Amount: ", :at => [330,217], :style => :bold
        @document.text_box "#{@booking.payment.amount}", :at => [480,217], :style => :bold, :align => :right

        @document
    end
end