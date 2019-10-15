# User model - Devise powered
class User < ApplicationRecord
  # Include default and most extra devise modules. Only :omniauthable not used.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
  devise :pwned_password unless Rails.env.test?

  def send_devise_notification( notification, *args )
    devise_mailer.public_send( notification, self, *args ).deliver_later
  end
end
