# frozen_string_literal: true

# Methods that might be useful in templates on the main site
module MainSiteHelper
  include ActsAsTaggableOn::TagsHelper

  def current_user_can?( capability, category = :general )
    current_user&.can? capability, category
  end

  def current_user_is_admin?
    current_user&.admin?
  end

  def current_user_is_not_admin?
    !current_user_is_admin?
  end

  def insert( name )
    InsertSet.first.elements.where( name: name ).pick( :content )
  end

  def insert_type?( name, type )
    InsertSet.first.elements.where( name: name ).pick( :element_type ) == type
  end

  def setting( name )
    Setting.get( name, current_user )
  end

  def user_display_name( user = current_user )
    user.name
  end

  def user_profile_link( user = current_user )
    link_to user.name, shiny_profiles.profile_path( user.username )
  end
end
