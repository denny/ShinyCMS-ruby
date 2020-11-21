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

query = Blazer::Query.where( name: 'New user accounts' ).first_or_create!(
  description: 'New user accounts, with confirmed/unconfirmed status',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Email recipients
sql = <<~SQL.squish
  SELECT name, email,
         CASE confirmed_at WHEN NULL THEN 'Not Confirmed' ELSE 'Confirmed' END as status,
         DATE(created_at) AS created_on,
         DATE(confirmed_at) AS confirmed_on
    FROM email_recipients
   WHERE created_at >= {start_time}
     AND created_at <= {end_time}
SQL

query = Blazer::Query.where( name: 'New email recipients' ).first_or_create!(
  description: 'New email recipients (no user account), with confirmed/unconfirmed status',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Countries
sql = <<~SQL.squish
  WITH countries AS (
    SELECT country, count(*)
      FROM ahoy_visits
     WHERE started_at > {start_time}
       AND started_at < {end_time}
     GROUP BY country
     ORDER BY count
  )
  SELECT country, count::text as count
    FROM countries
SQL

query = Blazer::Query.where( name: 'Countries' ).first_or_create!(
  description: 'Countries that visits are from',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Devices
sql = <<~SQL.squish
  SELECT device_type, count(*)
    FROM ahoy_visits
   WHERE started_at >= {start_time}
     AND started_at <= {end_time}
   GROUP BY device_type
   ORDER BY count DESC
SQL

query = Blazer::Query.where( name: 'Device types' ).first_or_create!(
  description: 'Types of device',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Visitor Map
sql = <<~SQL.squish
  SELECT lat, lng
    FROM ahoy_visits
  WHERE started_at >= {start_time}
    AND started_at <= {end_time}
SQL

query = Blazer::Query.where( name: 'Visitor map' ).first_or_create!(
  description: 'Map view of visitor locations',
  data_source: 'shinycms',
  statement: sql
)
dashboard.queries << query if ENV[ 'MAPBOX_ACCESS_TOKEN' ].present? && !dashboard.queries.exists?( query.id )
