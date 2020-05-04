class ApplicationMailer < ActionMailer::Base
  default from: 'no-reply@gribbles.com.my'
  # default from: 'no-reply@biomarking.com'
  layout 'mailer'
end
