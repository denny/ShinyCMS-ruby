# Rails Email Preview controller for previewing Devise-powered user emails
class UserMailerPreview
  def confirmation
    UserMailer.registration fetch_user, fake_token
  end

  def reset_password
    UserMailer.reset_password fetch_user, fake_token
  end

  def password_changed
    UserMailer.password_changed fetch_user
  end

  def email_changed
    UserMailer.email_changed fetch_user
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
    # TODO: Use factory?
    User.first
  end
end
