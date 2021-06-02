# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Disable concurrent asset compilation

Sprockets.export_concurrent = false

# Failed CI run (one of many):
# https://app.circleci.com/pipelines/github/denny/ShinyCMS-ruby/3892/workflows/f45bbf6c-eb69-4ab5-a784-8aa3382604df/jobs/7856

# Discussion suggesting this initializer as a possible solution:
# https://github.com/sass/sassc-ruby/issues/207
