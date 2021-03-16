# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Admin area routes for stats features

get 'email-stats(/page/:page)',            to: 'email_stats#index',  as: :email_stats
get 'email-stats/user/:user_id',           to: 'email_stats#index',  as: :user_email_stats
get 'email-stats/recipient/:recipient_id', to: 'email_stats#index',  as: :recipient_email_stats
get 'email-stats/search',                  to: 'email_stats#search', as: :search_email_stats

get 'web-stats(/page/:page)',              to: 'web_stats#index',  as: :web_stats
get 'web-stats/user/:user_id',             to: 'web_stats#index',  as: :user_web_stats
get 'web-stats/search',                    to: 'web_stats#search', as: :search_web_stats
