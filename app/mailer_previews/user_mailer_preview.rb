# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Rails Email Preview controller for previewing Devise-powered user emails
class UserMailerPreview
  def confirmation_instructions
    UserMailer.confirmation_instructions fetch_user, fake_token
  end

  def reset_password_instructions
    UserMailer.reset_password_instructions fetch_user, fake_token
  end

  def password_changed_instructions
    UserMailer.password_changed_instructions fetch_user
  end

  def email_changed_instructions
    UserMailer.email_changed_instructions fetch_user
  end

  def unlock_instructions
    UserMailer.unlock_instructions fetch_user, fake_token
  end

  private

  def fetch_user
    @user_id ? User.find( @user_id ) : mock_user
  end

  def fake_token
    'PREVIEW_TOKEN'
  end

  def mock_user
    User.new(
      username: 'preview_user',
      email: 'preview_user@example.com'
    )
  end
end
