# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

FactoryBot.define do
  factory :group do
    internal_name { 'MyString' }
    public_name { 'MyString' }
    slug { 'MyString' }
    description { 'MyText' }
  end
end
