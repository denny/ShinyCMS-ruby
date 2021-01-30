# frozen_string_literal: true

# Set the host name for URL creation
hostname = ENV[ 'SITE_HOSTNAME'     ].presence || 'localhost:3000'
protocol = ENV[ 'SITE_URL_PROTOCOL' ].presence || 'https'
protocol = 'http' if Rails.env.development? || Rails.env.test?

SitemapGenerator::Sitemap.default_host =
  Rails.application.routes.url_helpers.root_url( host: hostname, protocol: protocol )

SitemapGenerator::Sitemap.create do
  def changefreq( created )
    age = Time.zone.now - created

    return 'daily'   if age < 1.week
    return 'weekly'  if age < 1.month
    return 'monthly' if age < 1.year

    'yearly'
  end

  if ShinyPlugin.loaded?( :ShinyPages ) && FeatureFlag.enabled?( :pages )
    ShinyPages::Page.readonly.visible.each do |page|
      next if page.default_page?

      add page.path, lastmod: page.updated_at, changefreq: changefreq( page.created_at )
    end
  end

  if ShinyPlugin.loaded?( :ShinyBlog ) && FeatureFlag.enabled?( :blog )
    ShinyBlog::Post.readonly.recent.each do |post|
      add post.path, lastmod: post.posted_at, changefreq: changefreq( post.posted_at )
    end
  end

  if ShinyPlugin.loaded?( :ShinyNews ) && FeatureFlag.enabled?( :news )
    ShinyNews::Post.readonly.recent.each do |post|
      add post.path, lastmod: post.posted_at, changefreq: changefreq( post.posted_at )
    end
  end
end
