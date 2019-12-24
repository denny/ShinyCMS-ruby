# Model class for blog posts
class BlogPost < ApplicationRecord
  belongs_to :user
  belongs_to :blog

  delegate :month, to: :posted_at
  delegate :year,  to: :posted_at
end
