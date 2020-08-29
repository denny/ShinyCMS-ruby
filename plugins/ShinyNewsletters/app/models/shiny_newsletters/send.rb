# frozen_string_literal: true

# ShinyNewsletters plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyNewsletters
  # Model for newsletter sends - when an edition is sent to a list
  class Send < ApplicationRecord
    # Scopes

    scope :sending,   -> { where( started_sending_at.present?  && finished_sending_at.blank? ) }
    scope :scheduled, -> { where( send_at.present?             && started_sending_at.blank?  ) }
    scope :sent,      -> { where( finished_sending_at.present? ) }
  end
end
