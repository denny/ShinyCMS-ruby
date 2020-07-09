# frozen_string_literal: true

# Track IP address of anonymous votable voters ('likes' feature)
class VotableIP < ApplicationRecord
  acts_as_voter
end
