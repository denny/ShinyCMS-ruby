# Rails Email Preview controller for previewing User-related emails
class UserMailerPreview
  def registration
    user = @user_id ? User.find( @user_id ) : mock_user
    UserMailer.registration user
  end

  private

  def mock_user
    # FactoryBot.create :user
    User.first
  end
end
