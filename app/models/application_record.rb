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
end
