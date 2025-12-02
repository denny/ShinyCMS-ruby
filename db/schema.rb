# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file is the source Rails uses to define your schema when running `rails db:schema:load`.
# When creating a new database, `rails db:schema:load` tends to be faster and is potentially
# less error prone than running all of your migrations from scratch. Old migrations may fail
# to apply correctly if those migrations use external dependencies or application code.

ActiveRecord::Schema[8.0].define(version: 2025_12_02_133022) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"
  enable_extension "pg_stat_statements"
  enable_extension "pgcrypto"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 0, null: false
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time", precision: 0
    t.index ["name", "time"], name: "index_ahoy_events_on_name_and_time"
    t.index ["properties"], name: "index_ahoy_events_on_properties", opclass: :jsonb_path_ops, using: :gin
    t.index ["user_id"], name: "index_ahoy_events_on_user_id"
    t.index ["visit_id"], name: "index_ahoy_events_on_visit_id"
  end

  create_table "ahoy_messages", force: :cascade do |t|
    t.string "user_type"
    t.bigint "user_id"
    t.text "to"
    t.string "mailer"
    t.text "subject"
    t.string "token"
    t.datetime "sent_at", precision: 0
    t.datetime "opened_at", precision: 0
    t.datetime "clicked_at", precision: 0
    t.index ["token"], name: "index_ahoy_messages_on_token"
    t.index ["user_type", "user_id"], name: "index_ahoy_messages_on_user_type_and_user_id"
  end

  create_table "ahoy_visits", force: :cascade do |t|
    t.string "visit_token"
    t.string "visitor_token"
    t.bigint "user_id"
    t.string "ip"
    t.text "user_agent"
    t.text "referrer"
    t.string "referring_domain"
    t.text "landing_page"
    t.string "browser"
    t.string "os"
    t.string "device_type"
    t.string "country"
    t.string "region"
    t.string "city"
    t.float "latitude"
    t.float "longitude"
    t.string "utm_source"
    t.string "utm_medium"
    t.string "utm_term"
    t.string "utm_content"
    t.string "utm_campaign"
    t.string "app_version"
    t.string "os_version"
    t.string "platform"
    t.datetime "started_at", precision: 0
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: 0
    t.index ["query_id"], name: "index_blazer_audits_on_query_id"
    t.index ["user_id"], name: "index_blazer_audits_on_user_id"
  end

  create_table "blazer_checks", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "query_id"
    t.string "state"
    t.string "schedule"
    t.text "emails"
    t.text "slack_channels"
    t.string "check_type"
    t.text "message"
    t.datetime "last_run_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "shiny_access_groups", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_access_groups_on_deleted_at"
    t.index ["slug"], name: "index_shiny_access_groups_on_slug"
  end

  create_table "shiny_access_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "user_id", null: false
    t.datetime "began_at", precision: 0, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "expires_at", precision: 0
    t.datetime "ended_at", precision: 0
    t.text "notes"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["began_at"], name: "index_shiny_access_memberships_on_began_at"
    t.index ["deleted_at"], name: "index_shiny_access_memberships_on_deleted_at"
    t.index ["ended_at"], name: "index_shiny_access_memberships_on_ended_at"
    t.index ["expires_at"], name: "index_shiny_access_memberships_on_expires_at"
    t.index ["group_id"], name: "index_shiny_access_memberships_on_group_id"
    t.index ["user_id"], name: "index_shiny_access_memberships_on_user_id"
  end

  create_table "shiny_blog_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body"
    t.boolean "show_on_site", default: true, null: false
    t.bigint "user_id", null: false
    t.datetime "posted_at", precision: 0, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_blog_posts_on_deleted_at"
    t.index ["user_id"], name: "index_shiny_blog_posts_on_user_id"
  end

  create_table "shiny_forms_forms", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.string "handler", null: false
    t.string "email_to"
    t.string "filename"
    t.boolean "use_recaptcha", default: true
    t.boolean "use_akismet", default: true
    t.string "success_message"
    t.string "redirect_to"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_forms_forms_on_deleted_at"
    t.index ["slug"], name: "index_shiny_forms_forms_on_slug", unique: true
  end

  create_table "shiny_inserts_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.bigint "set_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_inserts_elements_on_deleted_at"
    t.index ["name"], name: "index_insert_elements_on_name", unique: true
    t.index ["set_id"], name: "index_shiny_inserts_elements_on_set_id"
  end

  create_table "shiny_inserts_sets", force: :cascade do |t|
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_inserts_sets_on_deleted_at"
  end

  create_table "shiny_lists_lists", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_lists_lists_on_deleted_at"
  end

  create_table "shiny_lists_subscriptions", force: :cascade do |t|
    t.bigint "list_id", null: false
    t.string "subscriber_type", null: false
    t.bigint "subscriber_id", null: false
    t.bigint "consent_version_id", null: false
    t.datetime "subscribed_at", precision: 0, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "unsubscribed_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["consent_version_id"], name: "index_shiny_lists_subscriptions_on_consent_version_id"
    t.index ["deleted_at"], name: "index_shiny_lists_subscriptions_on_deleted_at"
    t.index ["list_id"], name: "index_shiny_lists_subscriptions_on_list_id"
    t.index ["subscriber_type", "subscriber_id"], name: "shiny_lists_subscriptions_on_subscribers"
  end

  create_table "shiny_news_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body"
    t.boolean "show_on_site", default: true, null: false
    t.bigint "user_id", null: false
    t.datetime "posted_at", precision: 0, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_news_posts_on_deleted_at"
    t.index ["user_id"], name: "index_shiny_news_posts_on_user_id"
  end

  create_table "shiny_newsletters_edition_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "edition_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_newsletters_edition_elements_on_deleted_at"
    t.index ["edition_id"], name: "index_shiny_newsletters_edition_elements_on_edition_id"
  end

  create_table "shiny_newsletters_editions", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.string "from_name"
    t.string "from_email"
    t.string "subject"
    t.boolean "show_on_site", default: true, null: false
    t.bigint "template_id", null: false
    t.datetime "published_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_newsletters_editions_on_deleted_at"
    t.index ["template_id"], name: "index_shiny_newsletters_editions_on_template_id"
  end

  create_table "shiny_newsletters_sends", force: :cascade do |t|
    t.bigint "edition_id", null: false
    t.bigint "list_id", null: false
    t.datetime "send_at", precision: 0
    t.datetime "started_sending_at", precision: 0
    t.datetime "finished_sending_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_newsletters_sends_on_deleted_at"
    t.index ["edition_id"], name: "index_shiny_newsletters_sends_on_edition_id"
    t.index ["list_id"], name: "index_shiny_newsletters_sends_on_list_id"
  end

  create_table "shiny_newsletters_template_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "template_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_newsletters_template_elements_on_deleted_at"
    t.index ["template_id"], name: "index_shiny_newsletters_template_elements_on_template_id"
  end

  create_table "shiny_newsletters_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "filename", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_newsletters_templates_on_deleted_at"
  end

  create_table "shiny_pages_page_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "page_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_pages_page_elements_on_deleted_at"
    t.index ["page_id"], name: "index_shiny_pages_page_elements_on_page_id"
  end

  create_table "shiny_pages_pages", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.integer "position"
    t.boolean "show_in_menus", default: true, null: false
    t.boolean "show_on_site", default: true, null: false
    t.bigint "section_id"
    t.bigint "template_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_pages_pages_on_deleted_at"
    t.index ["section_id", "slug"], name: "index_pages_on_section_id_and_slug", unique: true
    t.index ["section_id"], name: "index_shiny_pages_pages_on_section_id"
    t.index ["template_id"], name: "index_shiny_pages_pages_on_template_id"
  end

  create_table "shiny_pages_sections", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.integer "position"
    t.boolean "show_in_menus", default: true, null: false
    t.boolean "show_on_site", default: true, null: false
    t.bigint "section_id"
    t.bigint "default_page_id"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["default_page_id"], name: "index_shiny_pages_sections_on_default_page_id"
    t.index ["deleted_at"], name: "index_shiny_pages_sections_on_deleted_at"
    t.index ["section_id", "slug"], name: "index_page_sections_on_section_id_and_slug", unique: true
    t.index ["section_id"], name: "index_shiny_pages_sections_on_section_id"
  end

  create_table "shiny_pages_template_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "template_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_pages_template_elements_on_deleted_at"
    t.index ["template_id"], name: "index_shiny_pages_template_elements_on_template_id"
  end

  create_table "shiny_pages_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "filename", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_pages_templates_on_deleted_at"
  end

  create_table "shiny_profiles_links", force: :cascade do |t|
    t.string "name", null: false
    t.string "url", null: false
    t.integer "position"
    t.bigint "profile_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_profiles_links_on_deleted_at"
    t.index ["profile_id"], name: "index_shiny_profiles_links_on_profile_id"
  end

  create_table "shiny_profiles_profiles", force: :cascade do |t|
    t.string "public_name"
    t.string "public_email"
    t.text "bio"
    t.string "location"
    t.string "postcode"
    t.boolean "show_on_site", default: true, null: false
    t.boolean "show_in_gallery", default: true, null: false
    t.boolean "show_to_unauthenticated", default: true, null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_shiny_profiles_profiles_on_deleted_at"
    t.index ["user_id"], name: "index_shiny_profiles_profiles_on_user_id", unique: true
  end

  create_table "shiny_shop_product_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "product_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_shiny_shop_product_elements_on_deleted_at"
    t.index ["product_id"], name: "index_shiny_shop_product_elements_on_product_id"
  end

  create_table "shiny_shop_products", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.integer "position"
    t.boolean "show_on_site", default: true, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.string "stripe_id"
    t.integer "price"
    t.boolean "active", default: false, null: false
    t.string "stripe_price_id"
    t.boolean "show_in_menus", default: true, null: false
    t.bigint "section_id"
    t.bigint "template_id"
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_shiny_shop_products_on_deleted_at"
    t.index ["section_id", "slug"], name: "index_products_on_section_id_and_slug", unique: true
    t.index ["section_id"], name: "index_shiny_shop_products_on_section_id"
    t.index ["stripe_id"], name: "index_shiny_shop_products_on_stripe_id", unique: true
    t.index ["stripe_price_id"], name: "index_shiny_shop_products_on_stripe_price_id", unique: true
    t.index ["template_id"], name: "index_shiny_shop_products_on_template_id"
  end

  create_table "shiny_shop_sections", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.integer "position"
    t.boolean "show_in_menus", default: true, null: false
    t.boolean "show_on_site", default: true, null: false
    t.bigint "section_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_shiny_shop_sections_on_deleted_at"
    t.index ["section_id", "slug"], name: "index_shop_sections_on_section_id_and_slug", unique: true
    t.index ["section_id"], name: "index_shiny_shop_sections_on_section_id"
  end

  create_table "shiny_shop_template_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "short_text", null: false
    t.integer "position"
    t.bigint "template_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_shiny_shop_template_elements_on_deleted_at"
    t.index ["template_id"], name: "index_shiny_shop_template_elements_on_template_id"
  end

  create_table "shiny_shop_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "filename", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.datetime "deleted_at", precision: nil
    t.index ["deleted_at"], name: "index_shiny_shop_templates_on_deleted_at"
  end

  create_table "shinycms_anonymous_authors", force: :cascade do |t|
  end

  create_table "shinycms_capabilities", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id"
    t.string "description"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["category_id"], name: "index_capabilities_on_category_id"
    t.index ["deleted_at"], name: "index_capabilities_on_deleted_at"
  end

  create_table "shinycms_capability_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_capability_categories_on_deleted_at"
  end

  create_table "shinycms_comments", force: :cascade do |t|
    t.bigint "discussion_id", null: false
    t.integer "number", null: false
    t.bigint "parent_id"
    t.string "title"
    t.text "body"
    t.string "ip_address"
    t.boolean "locked", default: false, null: false
    t.boolean "show_on_site", default: true, null: false
    t.boolean "spam", default: false, null: false
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "posted_at", precision: 0, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["author_id", "author_type"], name: "index_comments_on_author_id_and_author_type"
    t.index ["deleted_at"], name: "index_comments_on_deleted_at"
    t.index ["number", "discussion_id"], name: "index_comments_on_number_and_discussion_id", unique: true
    t.index ["parent_id"], name: "index_comments_on_parent_id"
  end

  create_table "shinycms_consent_versions", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "display_text", null: false
    t.text "admin_notes"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_consent_versions_on_deleted_at"
  end

  create_table "shinycms_discussions", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.boolean "locked", default: false, null: false
    t.boolean "show_on_site", default: true, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_discussions_on_deleted_at"
    t.index ["resource_type", "resource_id"], name: "index_discussions_on_resource_type_and_resource_id"
  end

  create_table "shinycms_do_not_contacts", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_do_not_contacts_on_deleted_at"
    t.index ["email"], name: "index_do_not_contacts_on_email", unique: true
  end

  create_table "shinycms_email_recipients", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "canonical_email", null: false
    t.uuid "token", default: -> { "gen_random_uuid()" }, null: false
    t.uuid "confirm_token"
    t.datetime "confirm_sent_at", precision: 0
    t.datetime "confirmed_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_email_recipients_on_deleted_at"
    t.index ["email"], name: "index_email_recipients_on_email", unique: true
    t.index ["token"], name: "index_email_recipients_on_token", unique: true
  end

  create_table "shinycms_feature_flags", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "enabled", default: false, null: false
    t.boolean "enabled_for_logged_in", default: false, null: false
    t.boolean "enabled_for_admins", default: false, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_feature_flags_on_deleted_at"
    t.index ["name"], name: "index_feature_flags_on_name", unique: true
  end

  create_table "shinycms_pseudonymous_authors", force: :cascade do |t|
    t.string "name", null: false
    t.string "url"
    t.inet "ip_address", null: false
    t.uuid "token", null: false
    t.bigint "email_recipient_id"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_comment_authors_on_deleted_at"
    t.index ["email_recipient_id"], name: "index_comment_authors_on_email_recipient_id"
  end

  create_table "shinycms_setting_values", force: :cascade do |t|
    t.bigint "setting_id", null: false
    t.bigint "user_id"
    t.string "value"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_setting_values_on_deleted_at"
    t.index ["setting_id", "user_id"], name: "index_setting_values_on_setting_id_and_user_id", unique: true
  end

  create_table "shinycms_settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "level", default: "site", null: false
    t.boolean "locked", default: true, null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_settings_on_deleted_at"
  end

  create_table "shinycms_user_capabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "capability_id", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["deleted_at"], name: "index_user_capabilities_on_deleted_at"
    t.index ["user_id", "capability_id"], name: "index_shinycms_user_capabilities_on_user_id_and_capability_id", unique: true, where: "(deleted_at IS NULL)"
  end

  create_table "shinycms_users", force: :cascade do |t|
    t.string "username", default: "", null: false
    t.string "email", default: "", null: false
    t.string "canonical_email", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "public_name"
    t.string "public_email"
    t.text "bio"
    t.string "website"
    t.string "location"
    t.string "postcode"
    t.text "admin_notes"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 0
    t.datetime "remember_created_at", precision: 0
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at", precision: 0
    t.datetime "last_sign_in_at", precision: 0
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: 0
    t.datetime "confirmation_sent_at", precision: 0
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at", precision: 0
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.datetime "deleted_at", precision: 0
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "shinycms_votable_ips", force: :cascade do |t|
    t.string "ip_address", null: false
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at", precision: 0
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "taggings_taggable_context_idx"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 0
    t.datetime "updated_at", precision: 0
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", precision: 0, null: false
    t.datetime "updated_at", precision: 0, null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "shiny_access_memberships", "shiny_access_groups", column: "group_id"
  add_foreign_key "shiny_access_memberships", "shinycms_users", column: "user_id"
  add_foreign_key "shiny_blog_posts", "shinycms_users", column: "user_id"
  add_foreign_key "shiny_inserts_elements", "shiny_inserts_sets", column: "set_id"
  add_foreign_key "shiny_lists_subscriptions", "shiny_lists_lists", column: "list_id"
  add_foreign_key "shiny_lists_subscriptions", "shinycms_consent_versions", column: "consent_version_id"
  add_foreign_key "shiny_news_posts", "shinycms_users", column: "user_id"
  add_foreign_key "shiny_newsletters_edition_elements", "shiny_newsletters_editions", column: "edition_id"
  add_foreign_key "shiny_newsletters_editions", "shiny_newsletters_templates", column: "template_id"
  add_foreign_key "shiny_newsletters_sends", "shiny_lists_lists", column: "list_id"
  add_foreign_key "shiny_newsletters_sends", "shiny_newsletters_editions", column: "edition_id"
  add_foreign_key "shiny_newsletters_template_elements", "shiny_newsletters_templates", column: "template_id"
  add_foreign_key "shiny_pages_page_elements", "shiny_pages_pages", column: "page_id"
  add_foreign_key "shiny_pages_pages", "shiny_pages_sections", column: "section_id"
  add_foreign_key "shiny_pages_pages", "shiny_pages_templates", column: "template_id"
  add_foreign_key "shiny_pages_sections", "shiny_pages_pages", column: "default_page_id"
  add_foreign_key "shiny_pages_sections", "shiny_pages_sections", column: "section_id"
  add_foreign_key "shiny_pages_template_elements", "shiny_pages_templates", column: "template_id"
  add_foreign_key "shiny_profiles_links", "shiny_profiles_profiles", column: "profile_id"
  add_foreign_key "shiny_profiles_profiles", "shinycms_users", column: "user_id"
  add_foreign_key "shiny_shop_product_elements", "shiny_shop_products", column: "product_id"
  add_foreign_key "shiny_shop_products", "shiny_shop_sections", column: "section_id"
  add_foreign_key "shiny_shop_products", "shiny_shop_templates", column: "template_id"
  add_foreign_key "shiny_shop_sections", "shiny_shop_sections", column: "section_id"
  add_foreign_key "shiny_shop_template_elements", "shiny_shop_templates", column: "template_id"
  add_foreign_key "shinycms_capabilities", "shinycms_capability_categories", column: "category_id"
  add_foreign_key "shinycms_comments", "shinycms_comments", column: "parent_id"
  add_foreign_key "shinycms_comments", "shinycms_discussions", column: "discussion_id"
  add_foreign_key "shinycms_setting_values", "shinycms_settings", column: "setting_id"
  add_foreign_key "shinycms_setting_values", "shinycms_users", column: "user_id"
  add_foreign_key "shinycms_user_capabilities", "shinycms_capabilities", column: "capability_id"
  add_foreign_key "shinycms_user_capabilities", "shinycms_users", column: "user_id"
  add_foreign_key "taggings", "tags"
end
