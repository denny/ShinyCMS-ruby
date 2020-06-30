# frozen_string_literal: true

# Common behaviours for models that have a posted_at date
module PostedAt
  extend ActiveSupport::Concern

  included do
    validates :posted_at, presence: true

    before_validation :set_posted_at, if: -> { posted_at.blank? }

    # Scopes

    scope :not_future_dated, -> { where( 'posted_at < current_timestamp' ) }

    # Instance methods

    def posted_month
      posted_at.strftime( '%m' )
    end

    def posted_year
      posted_at.strftime( '%Y' )
    end

    def posts_this_month
      self.class.readonly.where( posted_at: posted_at.beginning_of_month..posted_at.end_of_month )
    end

    def set_posted_at
      self.posted_at = Time.zone.now
    end

    # Class methods

    def self.posts_for_year( year_string )
      year = Date.new( year_string.to_i, 1, 1 ).beginning_of_day
      where( posted_at: year..year.end_of_year.end_of_day ).order( :posted_at ).readonly
    end

    def self.posts_for_month( year_string, month_string )
      month = Date.new( year_string.to_i, month_string.to_i, 1 ).beginning_of_day
      where( posted_at: month..month.end_of_month ).order( :posted_at ).readonly
    end
  end
end
