# frozen_string_literal: true
# This migration comes from shiny_cms (originally 20210226020652)

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class RenameCommentAuthors < ActiveRecord::Migration[6.1]
  def change
    rename_table :shinycms_comment_authors, :shinycms_pseudonymous_authors
  end
end
