# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Configuration for Algolia (Search as a Service)
if ENV['ALGOLIASEARCH_APPLICATION_ID']
  AlgoliaSearch.configuration = {
    application_id: ENV['ALGOLIASEARCH_APPLICATION_ID'],
    api_key:        ENV['ALGOLIASEARCH_API_KEY']
  }
end
