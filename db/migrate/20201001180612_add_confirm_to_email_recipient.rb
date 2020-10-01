# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

class AddConfirmToEmailRecipient < ActiveRecord::Migration[6.0]
  def change
    add_column :email_recipients, :confirm_token, :uuid
    add_column :email_recipients, :confirm_sent_at, :timestamp, precision: 6
    add_column :email_recipients, :confirmed_at, :timestamp, precision: 6
  end
end
