# frozen_string_literal: true
# This migration comes from shiny_cms (originally 20241106060001)

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class IndexAhoyVisits < ActiveRecord::Migration[6.1]
  def add
    add_index :ahoy_visits, [ :visitor_token, :started_at ]
  end
end
