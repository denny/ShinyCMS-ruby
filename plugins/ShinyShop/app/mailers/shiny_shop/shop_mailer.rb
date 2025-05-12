# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Mailer to send emails from shop features - part of the ShinyShop plugin for ShinyCMS
class ShinyShop::ShopMailer < ApplicationMailer
  layout 'shiny_shop/layouts/shop_mailer'

  def confirmation( customer_email )
    mail to: customer_email, subject: I18n.t( 'shiny_shop.mailers.shop_mailer.confirmation.subject' ) do |format|
      format.html
      format.text
    end
  end

  private

  def check_feature_flags
    enforce_feature_flags :shop
  end

  def check_ok_to_email
    enforce_ok_to_email @recipient_email
  end
end
