# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configuration for Algolia (Search as a Service)

# :nocov:

return if ENV[ 'ALGOLIASEARCH_API_KEY' ].blank? || ENV[ 'ALGOLIASEARCH_APPLICATION_ID' ].blank?

AlgoliaSearch.configuration = {
  application_id: ENV[ 'ALGOLIASEARCH_APPLICATION_ID' ],
  api_key:        ENV[ 'ALGOLIASEARCH_API_KEY'        ]
}
