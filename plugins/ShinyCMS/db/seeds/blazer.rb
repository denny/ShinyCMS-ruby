# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file sets up the default dashboard and queries for Blazer

# Several of these were copied or adapted from https://github.com/resool/blazer-demo

# :nocov: The tests don't need this data loaded
return if Rails.env.test?

return if ENV.fetch( 'DISABLE_BLAZER', 'false' ).downcase == 'true'

# Dashboard
dashboard = Blazer::Dashboard.where( name: 'Default Dashboard' ).first_or_create!

# Users
sql = <<~SQL.squish
  select date( created_at ) as accounts_created_on,
         case ( confirmed_at is not null ) when true then 'Confirmed' else 'Not confirmed' end as confirmation_status,
         count(*) as user_count
    from users
   where created_at between {start_time} and {end_time}
   group by 1, 2
   order by 1, 2
SQL

query = Blazer::Query.where( name: 'New user accounts' ).first_or_create!(
  description: 'Number of new user accounts created on each day in this range, split by confirmation status',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Comment authors
sql = <<~SQL.squish
  select date( created_at ) as first_posted_on,
         count(*) as author_count
    from comment_authors
   where created_at between {start_time} and {end_time}
   group by 1
   order by 1
SQL

query = Blazer::Query.where( name: 'New comment authors' ).first_or_create!(
  description: 'Number of first-time pseudonymous commenters for each day in this range',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Email recipients
sql = <<~SQL.squish
  select date( created_at ) as created_on,
         case ( confirmed_at is not null ) when true then 'Confirmed' else 'Not confirmed' end as confirmation_status,
         count(*) as recipient_count
    from email_recipients
   where created_at between {start_time} and {end_time}
   group by 1, 2
   order by 1, 2
SQL

query = Blazer::Query.where( name: 'New email recipients' ).first_or_create!(
  description: 'Number of new email recipients (subscribers who are not users) created on each day in this range',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Comments
sql = <<~SQL.squish
  select date(c.posted_at) as date_posted,
         d.resource_type as type_of_content,
         count(*) as comment_count
    from comments c, discussions d
   where c.discussion_id = d.id
     and c.posted_at between {start_time} and {end_time}
   group by 1, 2
   order by 1, 2
SQL

query = Blazer::Query.where( name: 'New comments' ).first_or_create!(
  description: 'Number of comments posted on each day in this range, for each type of content with comments',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Visits
sql = <<~SQL.squish
  select date( started_at ) as visit_started_on,
         case ( user_id is not null ) when true then 'Logged-in user' else 'Not logged-in' end as login_status,
         count(*) AS visits
    from ahoy_visits
   where started_at between {start_time} and {end_time}
   group by 1, 2
   union all
  select date( started_at ) as visit_started_on, 'All' as login_status, count(*) AS visits
    from ahoy_visits
   where started_at between {start_time} and {end_time}
   group by 1, 2
   order by 1 asc, 2 desc
SQL

query = Blazer::Query.where( name: 'All visits' ).first_or_create!(
  description: 'Total number of visits on each day in this range, and split by login status',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Most popular browsers
sql = <<~SQL.squish
  WITH browsers AS (
    select browser, count(*)
      from ahoy_visits
     where started_at between {start_time} and {end_time}
     group by 1
     order by 2 desc
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

query = Blazer::Query.where( name: 'Popular web browsers' ).first_or_create!(
  description: "Total number of visits between these dates, split by web browser used (shows top 4 and 'other')",
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# Devices
sql = <<~SQL.squish
  select device_type, count(*) as visits_from_device_type
    from ahoy_visits
   where started_at between {start_time} and {end_time}
   group by 1
   order by 1 desc
SQL

query = Blazer::Query.where( name: 'Device types' ).first_or_create!(
  description: 'Number of visits between these dates from each device type listed',
  data_source: 'shinycms',
  statement:   sql
)
dashboard.queries << query unless dashboard.queries.exists? query.id

# TODO: FIXME: we're not recording country data currently, so this is not very useful.
# Countries
# sql = <<~SQL.squish
#  select country, count(*) as visits_from_country
#    from ahoy_visits
#   where started_at between {start_time} and {end_time}
#   group by 1
#   order by 1 desc
# SQL
#
# query = Blazer::Query.where( name: 'Countries' ).first_or_create!(
#  description: 'Number of visits between these dates that came from each country listed',
#  data_source: 'shinycms',
#  statement: sql
# )
# dashboard.queries << query unless dashboard.queries.exists? query.id

# Access group memberships
if ShinyCMS.plugins.loaded? :ShinyAccess
  sql = <<~SQL.squish
    select date( began_at ) as began_on,
           g.internal_name as group_name,
           count(*) as memberships_begun
      from shiny_access_memberships m, shiny_access_groups g
     where m.group_id = g.id
       and began_at between {start_time} and {end_time}
     group by 1, 2
     order by 1, 2
  SQL

  query = Blazer::Query.where( name: 'Memberships that began on these dates' ).first_or_create!(
    description: 'Number of access control group memberships that began on each day in this range',
    data_source: 'shinycms',
    statement:   sql
  )
  dashboard.queries << query unless dashboard.queries.exists? query.id

  sql = <<~SQL.squish
    select date( ended_at ) as ended_on,
           g.internal_name as group_name,
           count(*) as memberships_ended
      from shiny_access_memberships m, shiny_access_groups g
     where m.group_id = g.id
       and ended_at between {start_time} and {end_time}
     group by 1, 2
     order by 1, 2
  SQL

  query = Blazer::Query.where( name: 'Memberships that ended on these dates' ).first_or_create!(
    description: 'Number of access control group memberships that ended on each day in this range',
    data_source: 'shinycms',
    statement:   sql
  )
  dashboard.queries << query unless dashboard.queries.exists? query.id
end

# Mailing list subscriptions
if ShinyCMS.plugins.loaded? :ShinyLists
  sql = <<~SQL.squish
    select date( subscribed_at ) as subscribed_on,
           l.internal_name as list_name,
           count(*) as subscription_count
      from shiny_lists_subscriptions s, shiny_lists_lists l
     where s.list_id = l.id
       and subscribed_at between {start_time} and {end_time}
     group by 1, 2
     order by 1, 2
  SQL

  query = Blazer::Query.where( name: 'Mailing list subscriptions' ).first_or_create!(
    description: 'Number of mailing list subscriptions on each day in this range',
    data_source: 'shinycms',
    statement:   sql
  )
  dashboard.queries << query unless dashboard.queries.exists? query.id

  sql = <<~SQL.squish
    select date( unsubscribed_at ) as unsubscribed_on,
           l.internal_name as list_name,
           count(*) as unsubscribe_count
      from shiny_lists_subscriptions s, shiny_lists_lists l
     where s.list_id = l.id
       and unsubscribed_at between {start_time} and {end_time}
     group by 1, 2
     order by 1, 2
  SQL

  query = Blazer::Query.where( name: 'Mailing list unsubscribes' ).first_or_create!(
    description: 'Number of mailing list unsubscribes on each day in this range',
    data_source: 'shinycms',
    statement:   sql
  )
  dashboard.queries << query unless dashboard.queries.exists? query.id
end
