# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Validator to check for MJML syntax errors in MJML template files
class MJMLSyntaxValidator < ActiveModel::Validator
  def validate( record )
    file = Tempfile.new [ 'shinycms-', '.mjml' ]

    file.write record.file_content_with_erb_removed
    file.rewind

    valid = system "node_modules/mjml/bin/mjml --validate #{file.path} 2>/dev/null"
    file.delete

    record.errors.add( :filename, :invalid_mjml ) unless valid
  end
end
