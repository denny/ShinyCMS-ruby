# Load ShinyCMS routes inside engines (e.g. Blazer)
# (Approach copied from RailsEmailPreview, which has this feature built in)
module MainAppRouteDelegator
  def method_missing( method, *args, &block )
    if main_app_route_method?( method )
      main_app.__send__( method, *args )
    else
      super
    end
  end

  def respond_to_missing?( method )
    super || main_app_route_method?( method )
  end

  private

  def main_app_route_method?( method )
    method.to_s =~ /_(?:path|url)$/ && main_app.respond_to?( method )
  end
end
