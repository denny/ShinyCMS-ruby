# frozen_string_literal: true

# Use Amazing Print gem to format console output
require 'amazing_print'
AmazingPrint.pry!

# Show app name and current environment in console prompt.
# Environment is shown in RED CAPITALS if it's not dev or test :)
if ENV[ 'PRETTY_PRY_PROMPT' ].present?
  def prompt_name( name )
    return name unless name.is_a?( Pry::Config )

    name.call
  end

  def app_name_for_pry_prompt
    Pry::Helpers::Text.cyan( 'ShinyCMS' )
  end

  def rails_env_for_pry_prompt
    return Pry::Helpers::Text.cyan  '(dev)'  if Rails.env.development?
    return Pry::Helpers::Text.green '(test)' if Rails.env.test?

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
