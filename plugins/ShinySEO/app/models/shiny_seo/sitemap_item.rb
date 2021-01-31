# frozen_string_literal: true

# ShinySEO plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinySEO
  # An item to be fed into SitemapGenerator; see [ShinySEO/]config/sitemap.rb
  class SitemapItem
    attr_reader :url, :content_updated_at, :update_frequency

    def initialize( resource )
      return if resource.nil?

      @resource = resource

      @url = "#{Sitemap.base_url}#{resource.path}"

      @content_updated    = explicit_content_updated_at || resource.updated_at
      @content_updated_at = @content_updated.iso8601

      @update_frequency = explicit_update_frequency || guesstimate_update_frequency
    end

    private

    def explicit_content_updated_at
      @resource.content_updated_at if @resource.respond_to? :content_updated_at
    end

    def explicit_update_frequency
      @resource.content_update_frequency if @resource.respond_to? :content_update_frequency
    end

    # TODO: CHECK ASSUMPTIONS!!! Are these the correct strings?
    #
    # How often should they check back, how soon do we expect the content to change again?
    def guesstimate_update_frequency
      return 'daily'   if daily?
      return 'weekly'  if weekly?
      return 'monthly' if monthly?

      'yearly'
    end

    def daily?
      @resource.created_at < 1.week.ago  || @content_updated < 2.days.ago
    end

    def weekly?
      @resource.created_at < 1.month.ago || @content_updated < 2.weeks.ago
    end

    def monthly?
      @resource.created_at < 1.year.ago  || @content_updated < 3.months.ago
    end
  end
end
