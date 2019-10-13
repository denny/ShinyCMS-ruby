# Pages controller
class PagesController < ApplicationController
  # Handle requests for the root page
  # /  (or /pages)
  def index
    @page = Page.default_page
    if @page
      show
      return
    end

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
  end

  # Handle requests with a single-part path
  # /pages/foo
  def show_top_level
    slug = params[ :slug ]

    # Is it a top-level page?
    @page = Page.top_level_pages&.find_by( slug: slug )
    show && return if @page

    # If not, is it a top-level section?
    @page = PageSection.top_level_sections&.find_by( slug: slug )&.default_page
    show && return if @page

    # If the slug matches neither, then call the 'not found' handler
    not_found
  end

  # Handle requests with a multi-part path
  # /pages/foo/bar, /pages/foo/bar/baz, /pages/etc/etc/etc
  def show_in_section
    path_parts = params[:slugs].split '/'
    slug = path_parts.pop
    section = traverse_path( path_parts, PageSection.top_level_sections )

    @page = section.pages&.find_by( slug: slug ) ||
            section.sections&.find_by( slug: slug )&.default_page
    show && return if @page

    not_found
  end

  private

  # Build the element stack and render the page
  def show
    unless @page.template.file_exists?
      render inline: I18n.t( 'template_file_missing' )
      return
    end

    build_menu_data

    # TODO: build element stack

    render template: "pages/templates/#{@page.template.filename}"
  end

  # Find the correct section to look for the specified (or default) page in
  def traverse_path( path_parts, sections )
    slug = path_parts.shift
    section = sections&.find_by( slug: slug )

    not_found && return unless section
    return section if path_parts.empty?

    traverse_path( path_parts, section.sections )
  end

  # Populate data used by the menu partial
  def build_menu_data
    @menu_tl_sections = PageSection.top_level_sections
    return unless @page

    if @page.section
      @menu_sections = @page.section.sections
      @menu_pages    = @page.section.pages
    else
      @menu_pages = Page.top_level_pages
    end
  end

  # 404 handler
  def not_found
    build_menu_data
    render status: :not_found, template: 'special/404.html.erb'
  end
end
