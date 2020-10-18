# ShinyCMS Developer Documentation

## Testing

ShinyCMS, including all the plugins, has [100% test coverage](https://codecov.io/gh/denny/ShinyCMS-ruby) (with a minimal amount of cheating, mostly around rake tasks)

### What should I test?

Please write tests for any and all new code that you add. At the very least, test the golden path with a request spec. If you're catching errors and turning them into helpful warnings for the user, you should also test that's working as intended. (And if you're not doing that, you probably should be.)

You should put extra testing around anything that has particularly bad consequences (e.g. data leaks, data loss, privilege escalation, etc) if it goes wrong.

It's also helpful to put extra tests around anything that's a bit unusual - the tests can double up as practical usage documentation.

### When should I test?

At minimum, you should run rubocop and the test suite, and fix any issues they find, before submitting a pull request. I recommend running them much more often than that. :)

### How do I test?

To run the linter: `rubocop`

To run the test suite: `rspec spec plugins` (from the project root directory)

To install git hooks to run rubocop and the tests automatically when you commit or push new code, install [Overcommit](https://github.com/sds/overcommit#readme) and follow its instructions - an Overcommit config file is included with ShinyCMS.
