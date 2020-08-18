# frozen_string_literal: true

module ShinySearch
  # Base mailer for <%= camelized_modules =>
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
