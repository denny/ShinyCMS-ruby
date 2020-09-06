# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Store details of people you send email to, who don't have a user account
# e.g. newsletter subscribers, pseudonymous comment reply notifications
class EmailRecipient < ApplicationRecord
  include ShinyDemoDataProvider
  include ShinyEmail
  include ShinyToken

  # Associations

  has_many :messages, class_name: 'Ahoy::Message', as: :user, dependent: :nullify

  # Email stats (powered by Ahoy)
  has_many :messages, as: :user, dependent: :nullify, class_name: 'Ahoy::Message'
end
