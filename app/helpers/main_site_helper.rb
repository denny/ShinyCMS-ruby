# Methods that might be useful in templates on the main site
module MainSiteHelper
  def current_user_can?( capability )
    return false unless current_user

    current_user.can? I18n.t( "capability.#{capability}" )
  end

  def shared_content( name )
    SharedContentElement.where( name: name ).pick( :content )
  end
end
