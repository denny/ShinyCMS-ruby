# Pages controller
class PagesController < ApplicationController
  # Main method to display a CMS-controlled page in the front end site
  def show
    # TODO: build element stack

    render template: "pages/templates/#{@page.template.filename}"
  end

  # Handle requests for the root page
  # /  (or /pages)
  def index
    @page = Page.default_page
    show && return if @page

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
    slug = params( :slug )

    # Is it a top-level page?
    @page = Page.top_level_pages&.find_by( slug: slug )
    show && return if @page

    # If not, is it a top-level section?
    @page = PageSection.top_level_sections&.find_by( slug: slug )&.default_page
    show && return if @page

    # If not, then bounce to the 'not found' handler
    render status: :not_found, template: 'special/404.html.erb'
  end

  # Handle requests with a multi-part path
  # /pages/foo/bar, /pages/foo/bar/baz, /pages/etc/etc/etc
  def show_in_section
    # We have multiple path parts, so we need to walk through them in order
    path_parts = params[:slugs].split '/'
    slug = path_parts.pop
    section = traverse_path( path_parts, PageSection.top_level_sections )

    @page = section.pages&.find_by( slug: slug ) ||
            section.sections&.find_by( slug: slug )&.default_page
    show && return if @page

    # b0rk
    render status: :not_found, template: 'special/404.html.erb'
  end

  private

  # Find the correct section to look for the specified (or default) page in
  def traverse_path( path_parts, sections )
    slug = path_parts.shift
    section = sections&.find_by( slug: slug )

    render status: :not_found, template: 'special/404.html.erb' unless section
    return section if path_parts.empty?

    traverse_path( path_parts, section.sections )
  end
end
