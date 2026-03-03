# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class RenameWebsiteColumn < ActiveRecord::Migration[6.1]
  def change
    rename_column :shinycms_pseudonymous_authors, :website, :url
  end
end
