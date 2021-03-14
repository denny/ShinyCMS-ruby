# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Plays the role of Author for anonymous Comments
  class AnonymousAuthor < ApplicationRecord
    has_many :comments, inverse_of: :author, dependent: :restrict_with_exception

    def name
      I18n.t 'shinycms.models.anonymous_author.anonymous'
    end

    def email; end

    def url; end
  end
end
