# frozen_string_literal: true

# Validator for attributes that only need to be unique within a collection
# e.g. page.slug within its section, blog_post.slug within the month of posting
class UniqueInCollectionValidator < ActiveRecord::Validations::UniquenessValidator
  def validate_each( record, attribute, value )
    @record = record
    @attribute = attribute

    @existing_error_count = error_count

    super
    return if globally_unique?

    remove_irrelevant_errors if unique_in_collection?( value )
  end

  private

  def error_count
    @record.errors[ @attribute ].size
  end

  def globally_unique?
    @existing_error_count == error_count
  end

  def unique_in_collection?( value )
    options[ :collection ].call( @record ).where( "#{@attribute} = ?", value ).blank?
  end

  def remove_irrelevant_errors
    irrelevant_error_count = error_count - @existing_error_count
    @record.errors[ @attribute ].pop( irrelevant_error_count )
  end
end
