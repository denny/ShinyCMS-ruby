# Shared element helper method, for use across the whole of the main site
module SharedContentHelper
  def shared_content( name )
    SharedContentElement.where( name: name ).pick( :content )
  end
end
