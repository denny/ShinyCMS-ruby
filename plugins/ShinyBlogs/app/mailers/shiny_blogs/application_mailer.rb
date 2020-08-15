# frozen_string_literal: true

module ShinyBlogs
  # Base mailer for <%= camelized_modules =>
  class ApplicationMailer < ActionMailer::Base
    default from: 'from@example.com'
    layout 'mailer'
  end
end
