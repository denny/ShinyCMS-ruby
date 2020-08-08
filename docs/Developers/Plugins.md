# ShinyCMS Developer Documentation

## Writing Plugins

### WARNING: UNFINISHED NOTES!!

cd ShinyCMS

rails plugin new --mountable --database=postgresql \
  --skip-gemfile-entry --skip-git --skip-keeps --skip-test --skip-system-test \
  --skip-puma --skip-spring --skip-turbolinks \
  --skip-action-mailer --skip-action-mailbox --skip-action-cable \
  --dummy-path=spec/dummy plugins/Shiny{Name}

cd plugins/Shiny{Name}

rm -f MIT-LICENSE

rubocop --auto-correct-all --only Style/FrozenStringLiteralComment
rubocop --auto-correct --only Layout/EmptyLineAfterMagicComment
rubocop --auto-correct --only Layout/TrailingEmptyLines
rubocop --auto-correct --only Style/GlobalStdStream
rubocop --auto-correct-all --only Style/RedundantFetchBlock

plugins/Shiny{Name}/spec/dummy/config/environments/development.rb
* Fix Rails.root.join() call params to be one string

## Files to edit (or generate from custom templates?)

plugins/Shiny{Name}/lib/shiny_{name}.rb
* Add top-level comment above module line

plugins/Shiny{Name}/app/*/shiny_{name}/application_*.rb
* Add top-level comment (between module and class lines)
* Remove forgery blah from controller (unnecessary since rails 5.2)

plugins/Shiny{Name}/shiny_{name}.gemspec
* Replace " with '
* Update various info strings
* Add required Ruby version (2.7)
* Change pg from dev dependency to main dependency, add version range
* Add rspec-rails dev dependency

lib/shiny_{name}/engine.rb
* Add FactoryBot config

lib/shiny_{name}/version.rb
* Match version to current CMS version

lib/tasks/shiny_{name}_tasks.rake
* Add shiny_{name}:db:seed task

README.md
* blah blah plugin blah blah
