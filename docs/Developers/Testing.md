# ShinyCMS Developer Documentation

## Testing

ShinyCMS, including all the plugins, has [100% test coverage](https://codecov.io/gh/denny/ShinyCMS-ruby) (with a minimal amount of cheating, mostly around rake tasks)

### What should I test?

Please write tests for any and all new code that you add. At the very least, test the golden path with a request spec. If you're catching errors and turning them into helpful warnings for the user, you should also test that's working as intended. (And if you're not doing that, you probably should be.)

You should put extra testing around anything that has particularly bad consequences if it goes wrong (e.g. data loss, data leaks, privilege escalation, etc).

It's also helpful to put extra tests around anything that's a bit unusual - your tests can potentially double up as practical usage documentation when other people are looking at your code.

### When should I test?

At minimum, you should run rubocop and the test suite, and fix any issues they find, before submitting a pull request. I recommend running them much more often than that :) They're particularly useful (and reassuring) when refactoring.

### How do I test?

To run the linter: `rubocop`

To run the test suite: `rspec spec/ plugins/` (from the project root directory)

> **Experimental feature**
>
> For a speedier test run, you can use the `tools/parallel-tests` script to run your tests in parallel across all the cores on your machine (this cuts the test time in half on my 12 core laptop).
>
> This feature is new, and it seems a tiny bit fragile currently, with occasional transient test failures. If it's too unreliable for you, just switch back to using the normal `rspec spec/ plugins/` instead.

To install git hooks to run rubocop and the tests automatically when you commit or push new code, install [Overcommit](https://github.com/sds/overcommit#readme) and follow its instructions - an Overcommit config file is included with ShinyCMS.
