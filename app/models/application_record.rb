# frozen_string_literal: true

# Application Record
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def url_helpers
    Rails.application.routes.url_helpers
  end

  def human_name
    name = self.class.name.underscore
    return name.humanize.downcase unless I18n.exists?( "content_types.#{name}" )

    I18n.t( "content_types.#{name}" )
  end

  # Updates auto-increment sequence for id after a manual insert (e.g. loading the demo data)
  def fix_primary_key_sequence
    ActiveRecord::Base.connection.execute(<<~SQL)
      BEGIN;
      LOCK TABLE #{table_name} IN EXCLUSIVE MODE;
      SELECT setval( '#{table_name}_id_seq', COALESCE( ( SELECT MAX(id)+1 FROM #{table_name} ), 1 ), false );
      COMMIT;
    SQL
  end
end
