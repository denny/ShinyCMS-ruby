# ShinyCMS Developer Documentation

## Code Quality

ShinyCMS includes config files and/or gems for a number of code quality tools and services.

### Rubocop

Rubocop is a linter which helps keep the code style consistent throughout the project, and in line with best practices that have been largely agreed in the Ruby community. There are a few items in the ShinyCMS rubocop configuration that are not default, mostly around whitespace and alignment.

Please make sure your code passes rubocop with the ShinyCMS config before submitting a PR; you can usually just use `rubocop -a` to autocorrect the whitespace for you.

### Ruby Critic

This is a tool you install and run locally. Currently it's having some dependency version issues with Ruby 3.0 and has been commented out in the ShinyCMS Gemfile, so you'll need to install it manually: `gem install rubycritic`

Ruby Critic runs three static code analysis tools - flog, reek - and then generates easy-to-read HTML reports of what they find. A config file is included at .rubycritic.yml which specifies which paths it should run the tools against - mainly it's the `app` directory in the main app and each plugin.

You generate an up-to-date report by running `rubycritic`. You can then find the report in `ShinyCMS/tmp/rubycritic/` and open it in any web browser to find files with potential code quality issues (complexity, duplication, etc).

### Other services

ShinyCMS is also checked for code quality with CodeClimate, CodeBeat, and CodeFactor, and there are config files for some of these where necessary/helpful (usually to ignore certain files).

ShinyCMS is also checked with Hakiri and Dependabot for potential security issues in the ShinyCMS code and/or its dependencies.
