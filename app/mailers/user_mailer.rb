# frozen_string_literal: true

# Mailer for user-related emails
class UserMailer < ApplicationMailer
  def registration( user )
    @user = user

    mail( to: user.email, subject: t( '.subject' ) ) do |format|
      format.mjml
      format.text
    end
  end
end
