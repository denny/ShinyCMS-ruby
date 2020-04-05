# Rails Email Preview controller for previewing Devise-powered user emails
class UserMailerPreview
  def registration
    DeviseMailer.registration fetch_user
  end

  private

  def fetch_user
    @user_id ? User.find( @user_id ) : mock_user
  end

  def mock_user
    # TODO: Use factory?
    User.first
  end
end
