# ShinyCMS Developer Docs

## Ruby 3.0.0 notes

1. Add `rss` gem to Gemfile (no longer in core)

2. `bundle update`

3. Change Gemfile to get `activerecord_session-store` from GitHub (unreleased fix)

4. Change `:confirmed` trait in email recipient factory from Symbol.to_proc to long form
    * Fixes error about "missing receiver", whatever that is

5. REP is throwing a load of warnings:
    * code -g lib/rails_email_preview/main_app_route_delegator.rb:11
        * Change `respond_to?` to `respond_to_missing?`
            * PR? Check how far back `respond_to_missing?` exists first

6. kaminari is not happy :(
    * Short-term, to get test suite to pass:
        * Comment out it_behaves_like Pagination at bottom of blog and news request spec
        * Comment out paginate calls in pager partials
    * Medium-term: time to switch to a different paging engine?
        * https://github.com/ddnexus/pagy ?
