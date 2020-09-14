# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.

ActiveRecord::Schema.define(version: 2020_09_06_152115) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "ahoy_events", force: :cascade do |t|
    t.bigint "visit_id"
    t.bigint "user_id"
    t.string "name"
    t.jsonb "properties"
    t.datetime "time"
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
    t.datetime "sent_at"
    t.datetime "opened_at"
    t.datetime "clicked_at"
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
    t.datetime "started_at"
    t.index ["user_id"], name: "index_ahoy_visits_on_user_id"
    t.index ["visit_token"], name: "index_ahoy_visits_on_visit_token", unique: true
  end

  create_table "blazer_audits", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "query_id"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at"
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
    t.datetime "last_run_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_checks_on_creator_id"
    t.index ["query_id"], name: "index_blazer_checks_on_query_id"
  end

  create_table "blazer_dashboard_queries", force: :cascade do |t|
    t.bigint "dashboard_id"
    t.bigint "query_id"
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["dashboard_id"], name: "index_blazer_dashboard_queries_on_dashboard_id"
    t.index ["query_id"], name: "index_blazer_dashboard_queries_on_query_id"
  end

  create_table "blazer_dashboards", force: :cascade do |t|
    t.bigint "creator_id"
    t.text "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_dashboards_on_creator_id"
  end

  create_table "blazer_queries", force: :cascade do |t|
    t.bigint "creator_id"
    t.string "name"
    t.text "description"
    t.text "statement"
    t.string "data_source"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["creator_id"], name: "index_blazer_queries_on_creator_id"
  end

  create_table "capabilities", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "category_id"
    t.string "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "capability_categories", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer "discussion_id", null: false
    t.integer "number", null: false
    t.bigint "parent_id"
    t.string "author_type"
    t.bigint "user_id"
    t.string "author_name"
    t.string "author_email"
    t.string "author_url"
    t.string "title"
    t.text "body"
    t.string "ip_address"
    t.boolean "locked", default: false, null: false
    t.boolean "show_on_site", default: true, null: false
    t.boolean "spam", default: false, null: false
    t.datetime "posted_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number", "discussion_id"], name: "index_comments_on_number_and_discussion_id", unique: true
  end

  create_table "consent_versions", force: :cascade do |t|
    t.string "name", null: false
    t.string "slug", null: false
    t.text "display_text", null: false
    t.text "admin_notes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "discussions", force: :cascade do |t|
    t.string "resource_type"
    t.bigint "resource_id"
    t.boolean "locked", default: false, null: false
    t.boolean "show_on_site", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["resource_type", "resource_id"], name: "index_discussions_on_resource_type_and_resource_id"
  end

  create_table "do_not_contacts", force: :cascade do |t|
    t.string "email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_do_not_contacts_on_email", unique: true
  end

  create_table "email_recipients", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "canonical_email", null: false
    t.uuid "token", default: -> { "gen_random_uuid()" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_email_recipients_on_email", unique: true
    t.index ["token"], name: "index_email_recipients_on_token", unique: true
  end

  create_table "feature_flags", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.boolean "enabled", default: false, null: false
    t.boolean "enabled_for_logged_in", default: false, null: false
    t.boolean "enabled_for_admins", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_feature_flags_on_name", unique: true
  end

  create_table "pg_search_documents", force: :cascade do |t|
    t.text "content"
    t.string "searchable_type"
    t.bigint "searchable_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["searchable_type", "searchable_id"], name: "index_pg_search_documents_on_searchable_type_and_searchable_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "setting_values", force: :cascade do |t|
    t.bigint "setting_id", null: false
    t.bigint "user_id"
    t.string "value"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["setting_id", "user_id"], name: "index_setting_values_on_setting_id_and_user_id", unique: true
  end

  create_table "settings", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.string "level", default: "site", null: false
    t.boolean "locked", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shiny_blog_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body"
    t.boolean "show_on_site", default: true, null: false
    t.bigint "user_id"
    t.datetime "posted_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
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
    t.string "redirect_to"
    t.string "success_message"
    t.integer "sort_order"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shiny_inserts_elements", force: :cascade do |t|
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "Short Text", null: false
    t.bigint "set_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_insert_elements_on_name", unique: true
    t.index ["set_id"], name: "index_insert_elements_on_set_id"
  end

  create_table "shiny_inserts_sets", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shiny_lists_lists", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "shiny_lists_subscriptions", force: :cascade do |t|
    t.bigint "list_id"
    t.string "subscriber_type"
    t.bigint "subscriber_id"
    t.bigint "consent_version_id"
    t.datetime "subscribed_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "unsubscribed_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["consent_version_id"], name: "index_shiny_lists_subscriptions_on_consent_version_id"
    t.index ["list_id"], name: "index_shiny_lists_subscriptions_on_list_id"
    t.index ["subscriber_type", "subscriber_id"], name: "shiny_lists_subscriptions_on_subscribers"
  end

  create_table "shiny_news_posts", force: :cascade do |t|
    t.string "title", null: false
    t.string "slug", null: false
    t.text "body"
    t.boolean "show_on_site", default: true, null: false
    t.bigint "user_id"
    t.datetime "posted_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_shiny_news_posts_on_user_id"
  end

  create_table "shiny_pages_page_elements", force: :cascade do |t|
    t.bigint "page_id", null: false
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "Short Text", null: false
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["page_id"], name: "index_page_elements_on_page_id"
  end

  create_table "shiny_pages_pages", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.bigint "template_id", null: false
    t.bigint "section_id"
    t.integer "position"
    t.boolean "show_in_menus", default: true, null: false
    t.boolean "show_on_site", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_pages_on_section_id"
    t.index ["slug", "section_id"], name: "index_pages_on_slug_and_section_id", unique: true
  end

  create_table "shiny_pages_sections", force: :cascade do |t|
    t.string "internal_name", null: false
    t.string "public_name"
    t.string "slug", null: false
    t.text "description"
    t.bigint "default_page_id"
    t.bigint "section_id"
    t.integer "position"
    t.boolean "show_in_menus", default: true, null: false
    t.boolean "show_on_site", default: true, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["section_id"], name: "index_page_sections_on_section_id"
    t.index ["slug", "section_id"], name: "index_page_sections_on_slug_and_section_id", unique: true
  end

  create_table "shiny_pages_template_elements", force: :cascade do |t|
    t.bigint "template_id", null: false
    t.string "name", null: false
    t.string "content"
    t.string "element_type", default: "Short Text", null: false
    t.integer "position"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["template_id"], name: "index_page_template_elements_on_template_id"
  end

  create_table "shiny_pages_templates", force: :cascade do |t|
    t.string "name", null: false
    t.text "description"
    t.string "filename", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "taggings", id: :serial, force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
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
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "user_capabilities", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "capability_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "capability_id"], name: "index_user_capabilities_on_user_id_and_capability_id", unique: true
  end

  create_table "users", force: :cascade do |t|
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
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "votable_ips", force: :cascade do |t|
    t.string "ip_address", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type"
    t.bigint "votable_id"
    t.string "voter_type"
    t.bigint "voter_id"
    t.boolean "vote_flag"
    t.string "vote_scope"
    t.integer "vote_weight"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["votable_id", "votable_type", "vote_scope"], name: "index_votes_on_votable_id_and_votable_type_and_vote_scope"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable_type_and_votable_id"
    t.index ["voter_id", "voter_type", "vote_scope"], name: "index_votes_on_voter_id_and_voter_type_and_vote_scope"
    t.index ["voter_type", "voter_id"], name: "index_votes_on_voter_type_and_voter_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "capabilities", "capability_categories", column: "category_id"
  add_foreign_key "comments", "comments", column: "parent_id"
  add_foreign_key "comments", "discussions"
  add_foreign_key "setting_values", "settings"
  add_foreign_key "setting_values", "users"
  add_foreign_key "shiny_blog_posts", "users"
  add_foreign_key "shiny_inserts_elements", "shiny_inserts_sets", column: "set_id"
  add_foreign_key "shiny_news_posts", "users"
  add_foreign_key "shiny_pages_page_elements", "shiny_pages_pages", column: "page_id"
  add_foreign_key "shiny_pages_pages", "shiny_pages_sections", column: "section_id"
  add_foreign_key "shiny_pages_pages", "shiny_pages_templates", column: "template_id"
  add_foreign_key "shiny_pages_sections", "shiny_pages_sections", column: "section_id"
  add_foreign_key "shiny_pages_template_elements", "shiny_pages_templates", column: "template_id"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_capabilities", "capabilities"
  add_foreign_key "user_capabilities", "users"
end
