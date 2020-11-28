# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Config for the Pry developer console

# Use Amazing Print gem to format console output
require 'amazing_print'
AmazingPrint.pry!

# Show app name and current environment in console prompt.
# Environment is colour-coded to indicate how careful you should be :)
if Rails.env.development? || Rails.env.test? || ENV[ 'SHINYCMS_PRY_CONSOLE' ]&.downcase == 'true'
  def prompt_name( name )
    return name unless name.is_a?( Pry::Config )

    name.call
  end

  def app_name_for_pry_prompt
    Pry::Helpers::Text.cyan( 'ShinyCMS' )
  end

  def rails_env_for_pry_prompt
    return Pry::Helpers::Text.cyan   '(dev)'     if Rails.env.development?
    return Pry::Helpers::Text.green  '(test)'    if Rails.env.test?
    return Pry::Helpers::Text.orange '(staging)' if hostname.starts_with? 'staging'

    Pry::Helpers::Text.red "[#{Rails.env.upcase}]"
  end

  Pry::Prompt.add(
    :shiny_prompt, 'ShinyCMS rails console prompt'
  ) do |context, nesting, pry, seperator|
    format(
      '%<app_name>s %<rails_env>s [%<in_count>s] %<name>s(%<context>s)%<nesting>s%<separator>s ',
      name: prompt_name( pry.config.prompt_name ),
      app_name: app_name_for_pry_prompt,
      rails_env: rails_env_for_pry_prompt,
      in_count: pry.input_ring.count,
      context: Pry.view_clip( context ),
      nesting: ( nesting.positive? ? ":#{nesting}" : '' ),
      separator: seperator
    )
  end

  Pry.config.prompt = Pry::Prompt[ :shiny_prompt ]
end
