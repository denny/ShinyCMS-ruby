# ShinyCMS Developer Docs

## Ruby 3.0.0 notes

* Added `rss` gem to Gemfile (no longer in core)

* Installing `activerecord_session-store` from GitHub, to pick up an unreleased fix

* Changed `:confirmed` trait in email recipient factory from Symbol.to_proc to long form
    * Fixes error about "missing receiver", whatever that is

* REP is throwing a load of warnings
    * Local fix:
        * code -g lib/rails_email_preview/main_app_route_delegator.rb:11
        * Change `respond_to?` to `respond_to_missing?`
    * PR? Check how far back `respond_to_missing?` exists first
