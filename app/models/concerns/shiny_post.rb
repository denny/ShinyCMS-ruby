# frozen_string_literal: true

# Common behaviours for 'post' type models (blog post, news post, etc)
module ShinyPost
  extend ActiveSupport::Concern

  include ShinyShowHide
  include ShinySlugInMonth
  include ShinyTeaser

  included do
    # Validations

    validates :body,      presence: true
    validates :title,     presence: true
    validates :user_id,   presence: true
    validates :posted_at, presence: true

    before_validation :set_posted_at, if: -> { posted_at.blank? }

    # Plugin features

    acts_as_taggable
    acts_as_votable
    paginates_per 20

    # Attribute aliases and delegated methods

    alias_attribute :author, :user

    delegate :show_on_site, to: :discussion, allow_nil: true, prefix: true
    delegate :locked, to: :discussion, allow_nil: true, prefix: true

    # Scopes and default sort order

    scope :not_future_dated, -> { where( 'posted_at <= ?', Time.zone.now.iso8601 ) }
    scope :published,        -> { visible.merge( not_future_dated ) }

    self.implicit_order_column = 'posted_at'

    # Instance methods

    def posted_month
      posted_at.strftime( '%m' )
    end

    def posted_year
      posted_at.strftime( '%Y' )
    end

    def posts_in_same_month
      self.class.readonly.published.where( posted_at: posted_at.all_month )
    end

    def set_posted_at
      self.posted_at = Time.zone.now.iso8601
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

    def self.recent_posts( page_num = 1 )
      order( posted_at: :desc ).readonly.page( page_num )
    end
  end
end
