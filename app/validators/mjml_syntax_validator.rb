# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Validator to check for MJML syntax errors in MJML template files
class MJMLSyntaxValidator < ActiveModel::Validator
  def validate( record )
    file = "#{record.class.template_dir}/#{record.filename}.html.mjml"

    mjml = File.read file
    mjml.gsub! %r{<%=? [^>]+ %>}, '' # Remove ERB tags

    parser = Mjml::Parser.new mjml
    parser.render
  rescue Mjml::Parser::ParseError
    record.errors.add( :filename, :invalid_mjml )
  end
end
