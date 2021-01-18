# frozen_string_literal: true

# ShinyPages plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyPages
  # Main site controller - ShinyPages plugin for ShinyCMS
  class PagesController < MainController
    include ShinyPages::MainSiteHelper

    before_action :enforce_html_format

    # Handle requests for the root page
    # /  (or /pages)
    def index
      @page = find_default_page

      return show_page if @page

      # rubocop:disable Rails/RenderInline
      render inline: <<~HTML
        <p>
          This site does not have any content yet. Please try again later.
        </p>
        <p>
          <i>
            Powered by <a href="https://shinycms.org/">ShinyCMS<a/>
            (<a href="https://shinycms.org/ruby">Ruby version</a>)
          </i>
        </p>
      HTML
      # rubocop:enable Rails/RenderInline
    end

    # Figure out whether we're at top level or going deeper
    def show
      path_parts = params[ :path ].split '/'

      if path_parts.size == 1
        show_top_level( path_parts.first )
      else
        show_in_section( path_parts )
      end
    end

    private

    # Handle requests with a single-part path - e.g. /foo
    def show_top_level( slug )
      return if show_top_level_page( slug )
      return if show_top_level_section( slug )

      raise ActiveRecord::RecordNotFound, 'Page not found'
    end

    def show_top_level_page( slug )
      @page = find_top_level_page( slug )
      return unless @page

      show_page
      true
    end

    def show_top_level_section( slug )
      @page = find_top_level_section( slug )&.default_page
      return unless @page

      show_page
      true
    end

    # Handle requests with a multi-part path - e.g. /foo/bar, /foo/bar/baz, etc
    def show_in_section( path_parts )
      slug = path_parts.pop
      section = traverse_path( path_parts, top_level_sections )

      @page = page_for_last_slug( section, slug )
      show_page && return if @page

      raise ActiveRecord::RecordNotFound, 'Page not found'
    end

    # Render the page with the appropriate template
    def show_page
      if @page.template.file_exists?
        render template: "shiny_pages/pages/#{@page.template.filename}", locals: @page.elements_hash
      else
        # rubocop:disable Rails/RenderInline
        render status: :failed_dependency, inline: I18n.t( 'shiny_pages.page.template_file_missing' )
        # rubocop:enable Rails/RenderInline
      end
    end

    # Find the correct section to look for the specified (or default) page in
    def traverse_path( path_parts, sections )
      slug = path_parts.shift
      section = sections&.find_by( slug: slug )

      return section if path_parts.empty? || section.nil?

      traverse_path( path_parts, section.sections )
    end

    def page_for_last_slug( section, slug )
      section&.pages&.find_by( slug: slug ) || section&.sections&.find_by( slug: slug )&.default_page
    end

    def enforce_html_format
      request.format = :html
    end
  end
end
