# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Validator for attributes that only need to be unique within a collection
# e.g. blog_post.slug within the month of posting
class UniqueInCollectionValidator < ActiveRecord::Validations::UniquenessValidator
  def validate_each( record, attribute, value )
    existing_error_count = record.errors[ attribute ].size
    super
    updated_error_count = record.errors[ attribute ].size

    uniqueness_error_count = updated_error_count - existing_error_count
    return if uniqueness_error_count.zero? # globally unique

    return unless unique_in_collection?( record, attribute, value )

    remove_irrelevant_errors( record, attribute, uniqueness_error_count )
  end

  private

  def unique_in_collection?( record, attribute, value )
    options[ :collection ].call( record ).where( attribute => value ).where.not( id: record.id ).blank?
  end

  def remove_irrelevant_errors( record, attribute, irrelevant_error_count )
    record.errors[ attribute ].pop( irrelevant_error_count )
  end
end
