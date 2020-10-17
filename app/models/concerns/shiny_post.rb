# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Common behaviours for 'post' type models (blog post, news post, etc)
module ShinyPost
  extend ActiveSupport::Concern

  include ShinySearch::Searchable if ShinyPlugin.loaded? :ShinySearch
  include ShinyClassName
  include ShinyShowHide
  include ShinySlugInMonth
  include ShinyTeaser

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

    acts_as_taggable
    acts_as_votable
    acts_as_paranoid
    validates_as_paranoid
    paginates_per 20

    searchable_by :title, :body, :slug if ShinyPlugin.loaded? :ShinySearch # TODO: author

    # Attribute aliases and delegated methods

    alias_attribute :author, :user

    delegate :show_on_site, to: :discussion, allow_nil: true, prefix: true
    delegate :locked, to: :discussion, allow_nil: true, prefix: true

    attr_writer :posted_at_time

    # Scopes and default sort order

    scope :not_future_dated, -> { where( 'posted_at <= ?', Time.zone.now.iso8601 ) }
    scope :published,        -> { visible.merge( not_future_dated ) }
    scope :recent,           -> { published.merge( order( posted_at: :desc ) ) }

    self.implicit_order_column = 'posted_at'

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

    # Used by SlugInMonth validator
    def items_in_same_month
      self.class.readonly.published.where( posted_at: posted_at.all_month )
    end

    def set_posted_at
      self.posted_at = Time.zone.now.iso8601
    end

    def build_atom_feed
      self.class.module_parent::BuildAtomFeedJob.perform_later
    end

    # Class methods

    def self.posts_in_year( year_string )
      year = Date.new( year_string.to_i, 1, 1 ).beginning_of_day
      where( posted_at: year.all_year ).order( :posted_at ).published.readonly
    end

    def self.posts_in_month( year_string, month_string )
      month = Date.new( year_string.to_i, month_string.to_i, 1 ).beginning_of_day
      where( posted_at: month.all_month ).order( :posted_at ).published.readonly
    end

    def self.find_post( year, month, slug )
      posts_in_month( year, month ).find_by( slug: slug )
    end
  end
end
