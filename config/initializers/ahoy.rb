# frozen_string_literal: true

# Initialiser for Ahoy web stats; picks up various privacy-related settings
# from ENV which are potentially useful for complying with GDPR.

# Set AHOY_LINK_USERS to the string 'false' to disable automatic linking of
# visits and users
class Ahoy::Store < Ahoy::DatabaseStore
  def authenticate( data )
    # :nocov:
    super unless ENV['AHOY_LINK_USERS'].presence == 'false'
    # :nocov:
  end
end

# Set AHOY_MASK_IPS to the string 'true' to mask IP addresses
# (sets the last part of the address to zeros before storing it)
Ahoy.mask_ips = true if ENV['AHOY_MASK_IPS'].presence == 'true'

# Set AHOY_COOKIES to the string 'false' to use anonymity sets instead
# https://privacypatterns.org/patterns/Anonymity-set
Ahoy.cookies = false if ENV['AHOY_COOKIES'].presence == 'false'

# Set to true for JavaScript tracking
Ahoy.api = false

# Disable geocoding until I figure out the geolite database licensing stuff
Ahoy.geocode = false
