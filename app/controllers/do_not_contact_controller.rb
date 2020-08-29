# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Main site controller for the Do Not Contact feature in ShinyCMS
class DoNotContactController < MainController
  # Display the permanent unsubscribe / 'do not contact' form
  def new; end

  # Add an email to the 'do not contact' list
  def create
    case DoNotContact.add( params[:email] )
    when :success
      flash[:notice] = t( '.success' )
    when :duplicate
      flash[:notice] = t( '.duplicate' )
    else
      flash[:alert] = t( '.failure' )
    end

    redirect_back fallback_location: do_not_contact_path
  end
end
