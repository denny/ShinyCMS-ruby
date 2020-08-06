# frozen_string_literal: true

module ShinyNews
  # ShinyNews base mailer
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
