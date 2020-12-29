# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Track email events with Ahoy
class EmailSubscriber
  def open( event )
    event[:controller].ahoy.track 'Email opened', message_id: event[:message].id
  end

  def click( event )
    event[:controller].ahoy.track 'Email clicked',
                                  message_id: event[:message].id,
                                  url:        event[:url]
  end
end

AhoyEmail.subscribers << EmailSubscriber.new

AhoyEmail.api = false
AhoyEmail.default_options[:open] = true
AhoyEmail.default_options[:click] = true
