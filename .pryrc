# frozen_string_literal: true

# Use awesome print to format console output
require 'amazing_print'
AmazingPrint.pry!

# Show app name and current environment in console prompt.
# Environment shown in RED CAPITALS if it's not dev or test :)
if ENV[ 'PRETTY_PRY_PROMPT' ].present?
  original_prompt = Pry.config.prompt

  app = Pry::Helpers::Text.cyan( 'ShinyCMS' )

  env =
    if Rails.env.development?
      Pry::Helpers::Text.green '(dev)'
    elsif Rails.env.test?
      Pry::Helpers::Text.yellow '(test)'
    else
      Pry::Helpers::Text.red "[#{Rails.env.upcase}]"
    end

  Pry.config.prompt = [
    proc { |*a| "#{app} #{env} #{original_prompt.first.call(*a)}"  },
    proc { |*a| "#{app} #{env} #{original_prompt.second.call(*a)}" }
  ]
end
