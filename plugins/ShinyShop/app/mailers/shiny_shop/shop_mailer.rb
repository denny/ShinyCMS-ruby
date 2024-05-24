# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2024 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Mailer to send emails from shop features - part of the ShinyShop plugin for ShinyCMS
  class ShopMailer < ApplicationMailer
    layout 'shiny_shop/layouts/shop_mailer'

    def confirmation( event )
      puts "Fulfilling order for #{checkout_session.inspect}"

      checkout_session = event['data']['object']

      @recipient_email = '2024@denny.me'  # FIXME
      mail to: @recipient_email, subject: 'Thank you!' do |format|
        format.html
        format.text
      end
    end

    private

    def check_feature_flags
      enforce_feature_flags :shop
    end

    def check_ok_to_email
      return true  # FIXME
      enforce_ok_to_email @recipient_email
    end
  end
end
