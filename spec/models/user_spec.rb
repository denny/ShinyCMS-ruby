# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

require 'rails_helper'

# Tests for user model
RSpec.describe User, type: :model do
  describe 'overridden find_first_by_auth_conditions method' do
    before do
      @user = create :user
    end

    it "finds the user if we submit a username as the 'login' param" do
      result = described_class.find_first_by_auth_conditions( login: @user.username )

      expect( result.id ).to eq @user.id
    end

    it "finds the user if we submit an email address as the 'login' param" do
      result = described_class.find_first_by_auth_conditions( login: @user.email )

      expect( result.id ).to eq @user.id
    end

    it "finds the user if we submit the 'email' param" do
      result = described_class.find_first_by_auth_conditions( email: @user.email )

      expect( result.id ).to eq @user.id
    end

    it "finds the user if we submit the 'username' param" do
      result = described_class.find_first_by_auth_conditions( username: @user.username )

      expect( result.id ).to eq @user.id
    end
  end

  describe 'concerns' do
    it_behaves_like ShinyEmail do
      let( :addressee ) { create :user }
    end

    it_behaves_like 'VoteableVoter' do
      let( :voter ) { create :user }
    end
  end
end
