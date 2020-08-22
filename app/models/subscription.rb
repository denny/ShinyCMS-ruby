# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Model for mailing list subscriptions
class Subscription < ApplicationRecord
  include ShinyDemoDataProvider

  # Associations

  belongs_to :subscriber, inverse_of: :subscriptions, polymorphic: true
  belongs_to :list,       inverse_of: :subscriptions, class_name: 'MailingList'

  has_one :consent, inverse_of: :purpose, dependent: :destroy

  # Validations

  validates :subscriber, presence: true
  validates :list,       presence: true
end
