# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # An item to be fed into SitemapGenerator; see [ShinySEO/]config/sitemap.rb
  class SitemapItem
    attr_reader :url, :content_updated_at, :check_for_updates

    def initialize( resource )
      return if resource.nil?

      @resource = resource

      @url = "#{base_url}#{resource.path}"

      @content_updated_obj = explicit_content_updated_at || resource.updated_at
      @content_updated_at  = @content_updated_obj.iso8601

      @check_for_updates = explicit_update_frequency || guesstimate_update_frequency
    end

    private

    # Find the hostname and protocol to use when creating URLs
    def base_url
      hostname = ENV[ 'SITE_HOSTNAME'     ].presence || 'localhost:3000'
      protocol = ENV[ 'SITE_URL_PROTOCOL' ].presence || 'https'
      protocol = 'http' if Rails.env.development? || Rails.env.test?

      Rails.application.routes.url_helpers.root_url( host: hostname, protocol: protocol ).chop
    end

    def explicit_content_updated_at
      @resource.content_updated_at if @resource.respond_to? :content_updated_at
    end

    def explicit_update_frequency
      @resource.content_update_frequency if @resource.respond_to? :content_update_frequency
    end

    # TODO: CHECK ASSUMPTIONS!!! Are these the correct strings?
    #
    # How often do we expect the content to change in future? How soon should they check back?
    def guesstimate_update_frequency
      return 'daily'   if daily?
      return 'weekly'  if weekly?
      return 'monthly' if monthly?

      'yearly'
    end

    def daily?
      @resource.created_at < 1.week.ago  || @content_updated_obj < 2.days.ago
    end

    def weekly?
      @resource.created_at < 1.month.ago || @content_updated_obj < 2.weeks.ago
    end

    def monthly?
      @resource.created_at < 1.year.ago  || @content_updated_obj < 3.months.ago
    end
  end
end
