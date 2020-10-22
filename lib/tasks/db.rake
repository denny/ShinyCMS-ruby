# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Make rake db:seed a bit cleverer - allow reloading/refreshing of seed data
# https://gist.github.com/koffeinfrei/04bbe38f16ff9d49bebd

namespace :db do
  task seed: :seed_helper

  task seed_helper: :environment do
    def seed( model, find_or_create_by, update_with = {} )
      record = model.where( find_or_create_by ).first_or_initialize

      return record if record.update( update_with )

      # :nocov:
      raise RuntimeError "Couldn't save #{record.class} (#{record.errors.full_messages.join( ', ' )})"
      # :nocov:
    end
  end
end
