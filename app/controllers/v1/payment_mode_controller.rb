class V1::PaymentModeController < ApplicationController
    before_action :must_be_authenticated

    def index 
        @modes = PaymentMode.all
    end
end
