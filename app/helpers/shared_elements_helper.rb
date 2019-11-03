# Shared element helper method, for use across the whole of the main site
module SharedElementsHelper
  def shared_element( name )
    SharedElement.where( name: name ).pick( :content )
  end
end
