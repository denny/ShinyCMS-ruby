# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# The ShinyHostApp `.rspec` file contains `--require spec_helper`, which means that
# `/spec/spec_helper.rb` will always be loaded (no need to explicitly require it in
# spec files). In turn, the only thing that file does is require this one.
#
# (The .rspec file also currently requires and enables RSpec::Instafail,
# because it doesn't seem to work when I move its config into this file)
#
# Because this config is always loaded, it's good practice to keep it as
# lightweight as possible. Every heavyweight dependency in this file will
# add to the boot time of the test suite on EVERY test run - even when
# running a single spec file, testing code with minimal actual requirements.
#
# Rails-specific test config lives in `plugins/ShinyCMS/spec/rails_helper.rb`
#
# RSpec config docs: http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration

require 'simplecov'

RSpec.configure do |config|
  config.before( :suite ) do
    # Copy fresh TEST theme templates into place
    FileUtils.rm_r 'themes/TEST' if Dir.exist? 'themes/TEST'
    FileUtils.cp_r 'plugins/ShinyCMS/spec/fixtures/TEST', 'themes/TEST'
  end

  # This setting specifies which spec files to load when `rspec` is run without
  # filename arguments. By default rspec just loads the files in the main app's
  # spec/ directory. The pattern below also loads all of the plugin spec files.
  config.pattern = '**/*_spec.rb,../plugins/*/spec/**/*_spec.rb'

  if config.files_to_run.size == 1
    # Use doc formatter, for more detailed output
    config.formatter = 'doc'
  else
    if ENV['SPECMAN']
      # This is currently making me smile. I hope you enjoy it too.
      config.formatter = 'RspecPacmanFormatter::Pacman'
    else
      # Use the (default) progress formatter, for more compact output
      config.formatter = 'progress'
    end

    # Optionally, show the slowest examples and example groups at the end of the run
    config.profile_examples = ENV[ 'SHOW_SLOW_SPECS' ].to_i if ENV[ 'SHOW_SLOW_SPECS' ]

    # Generate new coverage report
    SimpleCov.start do
      add_filter '/spec/'
    end

    # Check whether we're on CI, and generate CodeCov report if so
    if ENV['CI'] == 'true'
      require 'codecov'
      require 'simplecov_json_formatter'
      SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
        [ SimpleCov::Formatter::Codecov, SimpleCov::Formatter::JSONFormatter ]
      )
    end
  end

  # rspec-expectations config. You can use an alternate assertion/expectation
  # library such as wrong or the stdlib/minitest assertions if you prefer.
  config.expect_with :rspec do |expectations|
    # This option makes the `description` and `failure_message` of custom matchers
    # include text for helper methods. It will default to `true` in RSpec 4.
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This will default to `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  # This option will default to `:apply_to_host_groups` in RSpec 4 (and will
  # have no way to turn it off -- the option exists only for backwards
  # compatibility in RSpec 3). It causes shared context metadata to be
  # inherited by the metadata hash of host groups and examples, rather than
  # triggering implicit auto-inclusion in groups with matching metadata.
  config.shared_context_metadata_behavior = :apply_to_host_groups

  # The settings below are suggested to provide a good initial experience
  # with RSpec, but feel free to customize to your heart's content.

  # This allows you to limit a spec run to individual examples or groups
  # you care about by tagging them with `:focus` metadata. When nothing
  # is tagged with `:focus`, all examples get run. RSpec also provides
  # aliases for `it`, `describe`, and `context` that include `:focus`
  # metadata: `fit`, `fdescribe` and `fcontext`, respectively.
  # config.filter_run_when_matching :focus

  # Allows RSpec to persist some state between runs in order to support
  # the `--only-failures` and `--next-failure` CLI options. We recommend
  # you configure your source control system to ignore this file.
  config.example_status_persistence_file_path = 'spec/examples.txt'

  # Limits the available syntax to the non-monkey patched syntax that is
  # recommended. For more details, see:
  #   - http://rspec.info/blog/2012/06/rspecs-new-expectation-syntax/
  #   - http://www.teaisaweso.me/blog/2013/05/27/rspecs-new-message-expectation-syntax/
  #   - http://rspec.info/blog/2014/05/notable-changes-in-rspec-3/#zero-monkey-patching-mode
  config.disable_monkey_patching!

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = :random

  # Seed global randomization in this process using the `--seed` CLI option.
  # Setting this allows you to use `--seed` to deterministically reproduce
  # test failures related to randomization by passing the same `--seed` value
  # as the one that triggered the failure.
  Kernel.srand config.seed
end
