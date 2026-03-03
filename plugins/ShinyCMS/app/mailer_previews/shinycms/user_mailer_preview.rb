# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Rails Email Preview controller for previewing Devise-powered user emails
  class UserMailerPreview
    def confirmation_instructions
      ShinyCMS::UserMailer.confirmation_instructions preview_user, 'PREVIEW_TOKEN'
    end

    def reset_password_instructions
      ShinyCMS::UserMailer.reset_password_instructions preview_user, 'PREVIEW_TOKEN'
    end

    def password_changed_instructions
      ShinyCMS::UserMailer.password_changed_instructions preview_user
    end

    def email_changed_instructions
      ShinyCMS::UserMailer.email_changed_instructions preview_user
    end

    def unlock_instructions
      ShinyCMS::UserMailer.unlock_instructions preview_user, 'PREVIEW_TOKEN'
    end

    private

    def preview_user
      ShinyCMS::User.new(
        username: 'preview_user',
        email:    'preview.user@example.com'
      )
    end
  end
end
