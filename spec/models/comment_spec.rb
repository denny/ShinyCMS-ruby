# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_should_behave_like 'Voteable' do
    let( :shiny_news_post  ) { create :shiny_news_post  }
    let( :discussion ) { create :discussion, resource: shiny_news_post }
    let( :item ) { create :comment, discussion: discussion }
  end

  it_should_behave_like 'ShinyDemoDataProvider' do
    let( :model ) { Blog }
  end
end
