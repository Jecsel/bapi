
class FormGenerator
    include Prawn::View
    require 'barby'
    require 'barby/barcode/code_39'
    require 'barby/outputter/prawn_outputter'

    attr_accessor   :campaign, :has_instructions, :no_of_blank_forms
                    

    def initialize (options={})
        @campaign           = Campaign.find options[:campaign_id]
        @has_instructions   = options[:has_instructions]
        @no_of_blank_forms  = options[:no_of_blank_forms]
        @document = Prawn::Document.new(:margin => 0, :size => "A4", :skip_page_creation => true)
    end

    def generate_gribbles_forms
        #With instructions
        case @has_instructions
        when true 
            unfilled_template = "#{Rails.root}/public/images/gribbles-request-form-template-with-instructions.jpg" 
            #Render forms for participants
            @campaign.campaign_participants.includes(:participant).order('participants.fullname ASC, participants.id ASC').active.each do |campaign_participant| 
                participant = campaign_participant.participant

                @document.start_new_page

                @document.font("#{Rails.root}/public/fonts/ek-mukta.light.ttf")
                @document.font_size(12)

                #Set image as template for pdf
                @document.image unfilled_template,
                    :at     => [25, [595.28, 791.89][1]],
                    :fit    => [595.28, 791.89]

                #Patient's name section
                @document.bounding_box([43,685], :width => 258, :height=>25) do #Removes input from user since field is required
                    stroke_color 'FFFFFF'
                    stroke_bounds
                    stroke do
                        stroke_color 'FFFFFF'
                        fill_color 'FFFFFF'
                        fill_and_stroke_rounded_rectangle [cursor - 30,cursor], 250, 25, 0
                        fill_color '000000'
                    end 
                end
                @document.text_box "#{participant.fullname}", :at => [43,692], :leading => -5, :width => 258, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                #DOB section
                @document.bounding_box([43,619], :width => 130, :height=>25) do #Removes input from user since field is required
                    stroke_color 'FFFFFF'
                    stroke_bounds
                    stroke do
                        stroke_color 'FFFFFF'
                        fill_color 'FFFFFF'
                        fill_and_stroke_rounded_rectangle [cursor - 30,cursor], 130, 25, 0
                        fill_color '000000'
                    end 
                end
                @document.text_box "#{participant.date_of_birth.strftime("%d/%m/%Y")}", :at => [43,630], :leading => -5, :width => 130, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                #IC/Passport section. Validate if participant has an ID
                if participant.id_number != ""
                    @document.bounding_box([43,647], :width => 180, :height=>15) do #Removes input from user since field is required
                        stroke_color 'FFFFFF'
                        stroke_bounds
                        stroke do
                            stroke_color 'FFFFFF'
                            fill_color 'FFFFFF'
                            fill_and_stroke_rounded_rectangle [cursor - 20,cursor], 180, 15, 0
                            fill_color '000000'
                        end 
                    end
                    @document.text_box "#{participant.id_number}", :at => [43,652], :leading => -5, :width => 180, :height=>18, :overflow => :shrink_to_fit 
                end

                #Gender checking
                if participant.gender != ""
                    @document.text_box "/", :at => [234,650], :width => 20, :height=>18, :overflow => :shrink_to_fit if participant.gender == "M"
                    @document.text_box "/", :at => [280,650], :width => 20, :height=>18, :overflow => :shrink_to_fit if participant.gender == "F"
                end

                #Barcode section
                #Form
                barcode = Barby::Code39.new(participant.barcode)
                outputter = Barby::PrawnOutputter.new(barcode)

                outputter.annotate_pdf(@document, :x => 205, :y => 595, :xdim => 0.7, :height => 10)
                @document.text_box "#{participant.barcode}", :at => [240,595], :width => 130, :height=>20, :size => 4

                #Instruction
                outputter.annotate_pdf(@document, :x => 465, :y => 22, :xdim => 0.7, :height => 10)
                @document.text_box "#{participant.barcode}", :at => [502,22], :width => 130, :height=>20, :size => 4


                #Mobile number section
                @document.text_box "#{participant.mobile}", :at => [47,588], :width => 100, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                
                #Campaign's details section
                @document.text_box "Doctor code: #{campaign_participant.campaign.campaign_doctor.code}", :at => [341,695], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Client name: #{campaign_participant.campaign.campaign_client.name}", :at => [341,680], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Billing code: #{campaign_participant.campaign.campaign_billing.name}", :at => [341,665], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 


                #Other test requests section
                @document.text_box "Package / Profile Code: #{campaign_participant.campaign.package}", :at => [140,198], :width => 200, :height=>30, :size => 10
                @document.text_box "Add on allowed? #{campaign_participant.campaign.optional_test ? "Y" : "N"}", :at => [140,186], :width => 100, :height=>30, :size => 10

                #Patient name for tearaway
                @document.bounding_box([303,127], :width => 130, :height=>10) do 
                    stroke_color 'FFFFFF'
                    stroke_bounds
                    stroke do
                        stroke_color 'FFFFFF'
                        fill_color 'FFFFFF'
                        fill_and_stroke_rounded_rectangle [cursor - 30,cursor], 130, 15, 0
                        fill_color '000000'
                    end 
                end
                @document.text_box "#{participant.fullname}", :at => [281,137], :width => 200, :height=>30, :size => 9, :leading => -8, :valign => :center, :overflow => :shrink_to_fit 
            end
            (1..@no_of_blank_forms).each do |blank_forms|
                
                @document.start_new_page
                @document.image unfilled_template,
                    :at     => [25, [595.28, 791.89][1]],
                    :fit    => [595.28, 791.89]

                #Campaign's details section
                @document.text_box "Doctor code: #{@campaign.campaign_doctor.code}", :at => [341,695], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Client name: #{@campaign.campaign_client.name}", :at => [341,680], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Billing code: #{@campaign.campaign_billing.name}", :at => [341,665], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 

                auto_barcode  = blank_form_barcode
                barcode = Barby::Code39.new(auto_barcode)
                outputter = Barby::PrawnOutputter.new(barcode)

                #Form
                outputter.annotate_pdf(@document, :x => 465, :y => 22, :xdim => 0.7, :height => 10)
                @document.text_box "#{barcode}", :at => [502,22], :width => 130, :height=>20, :size => 4

                #Instruction
                outputter.annotate_pdf(@document, :x => 205, :y => 595, :xdim => 0.7, :height => 10)
                @document.text_box "#{barcode}", :at => [240,595], :width => 130, :height=>20, :size => 4
            end 
        else
            unfilled_template = "#{Rails.root}/public/images/gribbles-request-form-template-without-instructions.jpg" 
            #Render forms for participants
            @campaign.campaign_participants.includes(:participant).order('participants.fullname ASC, participants.id ASC').active.each do |campaign_participant| 
                participant = campaign_participant.participant

                @document.start_new_page

                @document.font("#{Rails.root}/public/fonts/ek-mukta.light.ttf")
                @document.font_size(12)

                #Set image as template for pdf
                @document.image unfilled_template,
                    :at     => [20, [595.28, 800.89][1]],
                    :fit    => [595.28, 800.89]

                #Patient's name section
                @document.bounding_box([38,685], :width => 258, :height=>25) do #Removes input from user since field is required
                    stroke_color 'FFFFFF'
                    stroke_bounds
                    stroke do
                        stroke_color 'FFFFFF'
                        fill_color 'FFFFFF'
                        fill_and_stroke_rounded_rectangle [cursor - 30,cursor], 250, 25, 0
                        fill_color '000000'
                    end 
                end
                @document.text_box "#{participant.fullname}", :at => [38,686], :leading => -5, :width => 258, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                #DOB section
                @document.bounding_box([38,607], :width => 130, :height=>25) do #Removes input from user since field is required
                    stroke_color 'FFFFFF'
                    stroke_bounds
                    stroke do
                        stroke_color 'FFFFFF'
                        fill_color 'FFFFFF'
                        fill_and_stroke_rounded_rectangle [cursor - 30,cursor], 130, 25, 0
                        fill_color '000000'
                    end 
                end
                @document.text_box "#{participant.date_of_birth.strftime("%d/%m/%Y")}", :at => [38,615], :leading => -5, :width => 130, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                #IC/Passport section. Validate if participant has an ID
                if participant.id_number != ""
                    @document.bounding_box([38,642], :width => 180, :height=>18) do #Removes input from user since field is required
                        stroke_color 'FFFFFF'
                        stroke_bounds
                        stroke do
                            stroke_color 'FFFFFF'
                            fill_color 'FFFFFF'
                            fill_and_stroke_rounded_rectangle [cursor - 20,cursor], 180, 18, 0
                            fill_color '000000'
                        end 
                    end
                    @document.text_box "#{participant.id_number}", :at => [38,642], :leading => -5, :width => 180, :height=>18, :overflow => :shrink_to_fit 
                end

                #Gender checking
                if participant.gender != ""
                    @document.text_box "/", :at => [232,641], :width => 20, :height=>18, :overflow => :shrink_to_fit if participant.gender == "M"
                    @document.text_box "/", :at => [278,641], :width => 20, :height=>18, :overflow => :shrink_to_fit if participant.gender == "F"
                end

                #Barcode section
                barcode = Barby::Code39.new(participant.barcode)
                outputter = Barby::PrawnOutputter.new(barcode)

                outputter.annotate_pdf(@document, :x => 202, :y => 556, :xdim => 0.7, :height => 30)
                @document.text_box "#{participant.barcode}", :at => [226,558], :width => 130, :height=>20, :size => 9


                #Mobile number section
                @document.text_box "#{participant.mobile}", :at => [43,530], :width => 100, :height=>25, :valign => :center, :overflow => :shrink_to_fit 

                
                #Campaign's details section
                @document.text_box "Doctor code: #{campaign_participant.campaign.campaign_doctor.code}", :at => [340,695], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Client name: #{campaign_participant.campaign.campaign_client.name}", :at => [340,670], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Billing code: #{campaign_participant.campaign.campaign_billing.name}", :at => [340,645], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 


                #Other test requests section
                @document.text_box "Package / Profile Code: #{campaign_participant.campaign.package}", :at => [128,116], :width => 200, :height=>30, :size => 10
                @document.text_box "Add on allowed? #{campaign_participant.campaign.optional_test ? "Y" : "N"}", :at => [128,104], :width => 100, :height=>30, :size => 10
            end
            (1..@no_of_blank_forms).each do |blank_forms|
                @document.start_new_page
                @document.image unfilled_template,
                    :at     => [25, [595.28, 791.89][1]],
                    :fit    => [595.28, 791.89]

                #Campaign's details section
                @document.text_box "Doctor code: #{@campaign.campaign_doctor.code}", :at => [340,695], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Client name: #{@campaign.campaign_client.name}", :at => [340,670], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 
                @document.text_box "Billing code: #{@campaign.campaign_billing.name}", :at => [340,645], :width => 100, :height=>20, :size => 10, :valign => :center, :overflow => :shrink_to_fit 

                auto_barcode = blank_form_barcode
                barcode = Barby::Code39.new(auto_barcode)
                outputter = Barby::PrawnOutputter.new(barcode)

                outputter.annotate_pdf(@document, :x => 205, :y => 551, :xdim => 0.7, :height => 30)
                @document.text_box "#{barcode}", :at => [231,553], :width => 130, :height=>20, :size => 9
            end 
        end
        
        

        @document
    end

    def blank_form_barcode
        auto_gen = barcode_generate
        while !BiomarkBarcode.exists?(code: auto_gen)
            CampaignBarcode.create(campaign_id: @campaign.id, barcode: auto_gen)
            BiomarkBarcode.create(code: auto_gen)
            return auto_gen
        end
    end

    def barcode_generate
        return 'GE'+[*('A'..'Z')].shuffle[0,2].join+[*('0'..'9')].shuffle[0,4].join
    end
end