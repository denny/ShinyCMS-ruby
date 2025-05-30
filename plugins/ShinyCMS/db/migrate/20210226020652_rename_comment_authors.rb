# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class RenameCommentAuthors < ActiveRecord::Migration[6.1]
  def change
    rename_table :shinycms_comment_authors, :shinycms_pseudonymous_authors
  end
end
