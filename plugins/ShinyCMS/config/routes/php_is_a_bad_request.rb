# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Give requests for .php URLs the love and respect they deserve

match '*anything_ending_in.php', to: 'shinycms/errors#bad_request', as: :php_is_a_bad_request, via: :all
