# Record details of a user's consent (e.g. to be on one of your mailing lists)
class Consent < ApplicationRecord
  validates :purpose, presence: true

  belongs_to :purpose, inverse_of: :consent, polymorphic: true
end
