# frozen_string_literal: true

module ShinyForms
  # Base mailer for ShinyCMS forms plugin
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
