# Pages controller
class PagesController < ApplicationController
  def index
    @page = Page.default_page
    return if @page

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

  def show_top_level
    # We've only got one path part, so either we want a top-level page,
    # or we want the default page from a top-level section
    @page = Page.top_level_pages&.where( slug: :slug )&.first
    return if @page

    @page = PageSection.top_level_sections
                      &.where( slug: :slug )&.first&.default_page
    return if @page

    render status: :not_found, template: 'special/404.html.erb'
  end

  def traverse_path( path_parts, sections )
    slug = path_parts.shift
    section = sections&.where( slug: slug )&.first

    render status: :not_found, template: 'special/404.html.erb' unless section
    return section if path_parts.empty?

    traverse_path( path_parts, section.sections )
  end

  def show_in_section
    # We have multiple path parts, so we need to walk through them in order
    path_parts = split '/', :slugs
    slug = path_parts.pop
    section = traverse_path( path_parts, PageSection.top_level_sections )

    @page = section.pages&.where( slug: slug )&.first
    return if @page

    @page = section.sections&.where( slug: slug )&.first&.default_page
    return if @page

    # b0rk
    render status: :not_found, template: 'special/404.html.erb'
  end
end
