# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Common behaviours for 'post' type models (blog post, news post, etc)
  module Post
    extend ActiveSupport::Concern

    include ShinyCMS::CanHide
    include ShinyCMS::HasReadableName
    include ShinyCMS::HasSlugUniqueInMonth
    include ShinyCMS::HasTags
    include ShinyCMS::HasTeaser
    include ShinyCMS::HasVotes
    include ShinyCMS::SoftDelete

    included do
      # Associations

      has_one :discussion, as: :resource, dependent: :destroy

      # Validations

      validates :title,     presence: true
      validates :body,      presence: true
      validates :user_id,   presence: true
      validates :posted_at, presence: true

      # Callbacks

      before_validation :set_posted_at, if: -> { posted_at.blank? }
      after_commit      :build_atom_feed

      # Plugin features

      if ShinyCMS.plugins.loaded? :ShinySearch
        include ShinySearch::Searchable
        searchable_by :title, :body, :slug  # TODO: author
      end

      # Attribute aliases and delegated methods

      alias_attribute :author,    :user
      alias_attribute :slug_base, :title

      delegate :show_on_site, to: :discussion, allow_nil: true, prefix: true
      delegate :locked,       to: :discussion, allow_nil: true, prefix: true

      # Scopes and default sort order

      scope :not_future_dated,  -> { where( 'posted_at <= ?', Time.zone.now.iso8601 ) }
      scope :most_recent_first, -> { order( posted_at: :desc ) }
      scope :published,         -> { visible.merge( not_future_dated ) }
      scope :recent,            -> { published.merge( most_recent_first ) }

      mattr_accessor :implicit_order_column, default: :posted_at

      # Instance methods

      def posted_at_time
        posted_at&.time
      end

      def posted_month
        posted_at.strftime( '%m' )
      end

      def posted_year
        posted_at.strftime( '%Y' )
      end

      def next_post
        self.class.published.where( 'posted_at > ?', posted_at ).order( posted_at: :asc ).first
      end

      def prev_post
        self.class.published.where( 'posted_at < ?', posted_at ).order( posted_at: :desc ).first
      end

      alias_method :previous_post, :prev_post

      def set_posted_at
        self.posted_at = Time.zone.now.iso8601
      end

      def build_atom_feed
        self.class.module_parent::BuildAtomFeedJob.perform_later
      end

      def content_updated_at
        dates = [ posted_at, updated_at ]
        dates.push most_recent_comment_posted_at if most_recent_comment_posted_at

        dates.max
      end

      def most_recent_comment_posted_at
        discussion&.most_recent_comment&.posted_at
      end

      # Used by HasSlugUniqueInMonth validator
      def items_in_same_month
        self.class.readonly.published.where( posted_at: posted_at.all_month )
      end

      def self.sitemap_items
        recent.readonly
      end
    end

    class_methods do
      def posts_in_year( year_string )
        year = Date.new( year_string.to_i, 1, 1 ).beginning_of_day
        where( posted_at: year.all_year ).order( :posted_at ).published.readonly
      end

      def posts_in_month( year_string, month_string )
        month = Date.new( year_string.to_i, month_string.to_i, 1 ).beginning_of_day
        where( posted_at: month.all_month ).order( :posted_at ).published.readonly
      end

      def find_post( year, month, slug )
        post = posts_in_month( year, month ).find_by( slug: slug )
        return post if post

        raise ActiveRecord::RecordNotFound
      end

      def admin_search( search_term )
        where( 'title ilike ?', "%#{search_term}%" )
          .or( where( 'body ilike ?', "%#{search_term}%" ) )
          .most_recent_first
      end
    end
  end
end
