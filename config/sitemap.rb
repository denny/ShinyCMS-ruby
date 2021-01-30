# frozen_string_literal: true

# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://localhost:3000'

SitemapGenerator::Sitemap.create do
  if ShinyPlugin.loaded?( :ShinyPages ) && FeatureFlag.enabled?( :pages )
    ShinyPages::Page.readonly.visible.each do |page|
      next if page.default_page?

      add page.path, lastmod: page.updated_at
    end
  end

  if ShinyPlugin.loaded?( :ShinyBlog ) && FeatureFlag.enabled?( :blog )
    ShinyBlog::Post.readonly.recent.each do |post|
      add post.path, lastmod: post.posted_at
    end
  end

  if ShinyPlugin.loaded?( :ShinyNews ) && FeatureFlag.enabled?( :news )
    ShinyNews::Post.readonly.recent.each do |post|
      add post.path, lastmod: post.posted_at
    end
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
