# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file sets up the default dashboard and queries for Blazer

# Adapted from https://github.com/resool/blazer-demo

# Dashboard
dashboard = Blazer::Dashboard.where( name: 'Default' ).first_or_create!

# Users
sql = <<~SQL.squish
  SELECT username, email,
         CASE confirmed_at WHEN NULL THEN 'Not Confirmed' ELSE 'Confirmed' END as status,
         DATE(created_at) AS created_on,
         DATE(confirmed_at) AS confirmed_on
    FROM users
   WHERE created_at >= {start_time}
     AND created_at <= {end_time}
SQL

query = Blazer::Query.where( name: 'User accounts' ).first_or_create!(
  description: 'User accounts, with confirmed/unconfirmed status',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Most popular browsers
sql = <<~SQL.squish
  WITH browsers AS (
    SELECT browser, count(*)
      FROM ahoy_visits
     WHERE started_at > {start_time}
       AND started_at < {end_time}
     GROUP BY browser
     ORDER BY count desc
  ),
  tops AS (
    SELECT *
      FROM browsers
     LIMIT 4
  ),
  others AS (
    SELECT *
      FROM browsers
    OFFSET 4
  )
  SELECT *
    FROM tops
   UNION
  SELECT 'Other', SUM(count)
    FROM others
SQL

query = Blazer::Query.where( name: 'Browsers' ).first_or_create!(
  description: 'Most popular browsers',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id
