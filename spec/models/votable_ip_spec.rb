# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VotableIP, type: :model do
  it_should_behave_like 'VoteableVoter' do
    let( :voter ) { create :votable_ip }
  end
end
