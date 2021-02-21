# ShinyCMS Developer Documentation

## Testing

ShinyCMS, including all the plugins, has [100% test coverage](https://codecov.io/gh/denny/ShinyCMS-ruby), with a minimal amount of :nocov: cheating (mostly the rake tasks).

### How do I run the tests?

To run the test suite: `rspec`

To run the linter: `rubocop`

Both of these should be run from the project's root directory - they will check all the plugins in one run.

To test a single plugin, run `rspec plugins/Shiny{Thing}` from the project's root directory.

### How often should I run the tests?

At minimum, you should run rubocop and the test suite, and fix any issues they find, before submitting a pull request. I recommend running them much more often than that :) They're particularly useful (and reassuring) when refactoring.

#### How do I get git to do this for me? :)

To run various checks and tests automatically whenever you commit or push new code, install [Overcommit](https://github.com/sds/overcommit#readme) and follow its instructions - an Overcommit config file is included with ShinyCMS.

### What should I test?

Please write tests for any and all new code that you add. At the very least, test the golden path with a request spec. If you're catching errors and turning them into helpful warnings for the user, you should also test that's working as intended. (And if you're not doing that, you probably should be.)

You should put extra testing around anything that has particularly bad consequences if it goes wrong (e.g. data loss, data leaks, privilege escalation, etc).

It's also helpful to put extra tests around anything that's a bit unusual - your tests can potentially double up as practical usage documentation when other people are looking at your code.

### Parallel test runs

#### (Experimental feature!)

For a speedier test run, you can try the `tools/parallel-rspec` utility script. This uses the [parallel_tests](https://github.com/grosser/parallel_tests#readme) gem to run the tests in parallel, spread across all the cores on your machine. On my laptop this cuts the total time taken to run the test suite down from around 3 minutes to around 90 seconds, at the cost of working the CPU nearly flat out on all 12 cores - which doesn't really seem worth the fan noise, but YMMV.

The `parallel_tests` gem uses multiple databases (one per core) to achieve its magic; you will need to create these using `tools/parallel-rspec-create`, and refresh them with `tools/parallel-rspec-prepare` if you change the database structure.

(See `rails --tasks | grep parallel` for other available rake tasks for `parallel_tests`. If you use any of these rake tasks, make sure you pass them the same ENV vars that are passed into each command by the `tools/parallel-rspec*` utility scripts - in particular, `parallel_tests` doesn't seem to default to the test environment!)

Note: while adding this feature I had a few problems with 'flickering' tests - failing once, fine on a re-run. If you find `parallel-rspec` is unreliable for you, stick with normal `rspec` instead :)
