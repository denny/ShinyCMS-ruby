# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Connect email events to Ahoy so it's possible to track them if desired
class EmailSubscriber
  def open( event )
    event[:controller].ahoy.track 'Email opened', message_id: event[:message].id
  end

  def click( event )
    event[:controller].ahoy.track 'Email clicked', message_id: event[:message].id, url: event[:url]
  end
end

AhoyEmail.subscribers << EmailSubscriber.new

# For privacy reasons, ShinyCMS does not track email opens or clicks by default
# You can enable these features for your site on the Settings page in the admin area
AhoyEmail.default_options[ :open  ] = false
AhoyEmail.default_options[ :click ] = false

# Disable API because we don't currently use it
AhoyEmail.api = false
