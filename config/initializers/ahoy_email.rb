# frozen_string_literal: true

# Track email events with Ahoy
class EmailSubscriber
  def open( event )
    event[:controller].ahoy.track 'Email opened', message_id: event[:message].id
  end

  def click( event )
    event[:controller].ahoy.track 'Email clicked',
                                  message_id: event[:message].id,
                                  url: event[:url]
  end
end

AhoyEmail.subscribers << EmailSubscriber.new

# AhoyEmail.api = true
AhoyEmail.api = false
AhoyEmail.default_options[:open] = true
AhoyEmail.default_options[:click] = true
