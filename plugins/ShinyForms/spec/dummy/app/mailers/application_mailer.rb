# frozen_string_literal: true

# Base mailer for the dummy test app
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
