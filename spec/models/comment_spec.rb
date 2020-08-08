# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  it_should_behave_like 'Voteable' do
    skip 'Removing news feature, to replace with plugin version'

    let( :news_post  ) { create :news_post  }
    let( :discussion ) { create :discussion, resource: news_post }
    let( :item ) { create :comment, discussion: discussion }
  end

  it_should_behave_like 'ShinyDemoDataProvider' do
    skip 'Removing news feature, to replace with plugin version'

    let( :model ) { Comment }
  end
end
