# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file is invoked when the database is created with `rails db:setup` or reset
# with `rails db:reset`. You can reload this data at any time using `rails db:seed`.

# Hand over to the seed task in the ShinyCMS core plugin
Rake::Task[ 'shinycms:db:seed' ].invoke
