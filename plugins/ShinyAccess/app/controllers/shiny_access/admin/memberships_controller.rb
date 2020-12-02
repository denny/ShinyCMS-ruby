# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Admin controller for access group memberships - part of the ShinyAccess plugin for ShinyCMS
  class Admin::MembershipsController < AdminController
    before_action :stash_group
    before_action :stash_query, only: :search

    def index
      authorize Membership

      @memberships = memberships.page( page_number ).per( items_per_page )

      authorize @memberships if @memberships.present?
    end

    def search
      authorize Membership

      @memberships = search_results.page( page_number ).per( items_per_page )

      authorize @memberships if @memberships.present?
      render :index
    end

    def create
      authorize Membership

      if @group.add_member( user_for_create )
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert ] = t( '.failure' )
      end

      redirect_to group_memberships_path( @group )
    end

    # This marks a membership as ended - it doesn't delete the record of it
    def destroy
      authorize membership

      if membership.end
        flash[ :notice ] = t( '.success' )
      else
        flash[ :alert ] = t( '.failure' )
      end

      redirect_to group_memberships_path( @group )
    end

    # Override the breadcrumbs 'section' link to go back to the groups page
    def breadcrumb_link_text_and_path
      [ t( 'shiny_access.admin.groups.breadcrumb' ), groups_path ]
    end

    private

    def stash_group
      @group = Group.find( params[ :group_id ] )
    end

    def memberships
      @group.memberships.active_first.recent
    end

    def membership
      memberships.find( params[ :id ] )
    end

    def stash_query
      params.permit( :q )
      @query = params[ :q ]
    end

    def search_results
      memberships.admin_search( @query )
    end

    def strong_params
      params.require( :membership ).permit( :user_id, :username )
    end

    def user_for_create
      return User.find( strong_params[ :user_id ] ) if strong_params[ :user_id ].present?

      User.find_by( username: strong_params[ :username ] )
    end
  end
end
