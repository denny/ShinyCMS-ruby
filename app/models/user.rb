# User model - Devise powered
class User < ApplicationRecord
  # Include default and most extra devise modules. Only :omniauthable not used.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable
end
