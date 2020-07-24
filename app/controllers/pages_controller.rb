# frozen_string_literal: true

# ============================================================================
# Project:   ShinyCMS (Ruby version)
# File:      app/controllers/pages_controller.rb
# Purpose:   Controller for 'brochure page' features on a ShinyCMS-powered site
#
# Copyright: (c) 2009-2020 Denny de la Haye https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or
# modify it under the terms of the GPL (version 2 or later).
# ============================================================================
class PagesController < ApplicationController
  # Handle requests for the root page
  # /  (or /pages)
  def index
    @page = Page.readonly.default_page
    if @page
      show_page
      return
    end
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
      return
    end

    show_in_section( path_parts ) && return
  end

  private

  # Handle requests with a single-part path
  # /pages/foo
  def show_top_level( slug )
    return if show_top_level_page( slug )
    return if show_top_level_section( slug )

    not_found
  end

  def show_top_level_page( slug )
    @page = Page.readonly.top_level_pages&.find_by( slug: slug )
    return unless @page

    show_page
    true
  end

  def show_top_level_section( slug )
    @page = PageSection.readonly.top_level_sections&.find_by( slug: slug )&.default_page
    return unless @page

    show_page
    true
  end

  # Handle requests with a multi-part path
  # /pages/foo/bar, /pages/foo/bar/baz, /pages/etc/etc/etc
  def show_in_section( path_parts )
    slug = path_parts.pop
    section = traverse_path( path_parts, PageSection.readonly.top_level_sections )

    @page = section.pages&.find_by( slug: slug ) ||
            section.sections&.find_by( slug: slug )&.default_page
    show_page && return if @page

    not_found
  end

  # Render the page with the appropriate template
  def show_page
    unless @page.template.file_exists?
      # rubocop:disable Rails/RenderInline
      render status: :failed_dependency,
             inline: I18n.t( 'page.template_file_missing' )
      # rubocop:enable Rails/RenderInline
      return
    end

    render template: "pages/templates/#{@page.template.filename}",
           locals: @page.elements_hash
  end

  # Find the correct section to look for the specified (or default) page in
  def traverse_path( path_parts, sections )
    slug = path_parts.shift
    section = sections&.find_by( slug: slug )

    not_found && return unless section
    return section if path_parts.empty?

    traverse_path( path_parts, section.sections )
  end

  # 404 handler
  def not_found
    render status: :not_found, template: 'errors/404'
  end
end
