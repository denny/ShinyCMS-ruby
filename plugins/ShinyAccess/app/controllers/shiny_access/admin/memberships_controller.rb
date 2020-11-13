# frozen_string_literal: true

# ShinyAccess plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyAccess
  # Admin controller for access group memberships - part of the ShinyAccess plugin for ShinyCMS
  class Admin::MembershipsController < AdminController
    def index
      authorize Membership

      return if memberships.blank?

      @memberships = memberships.active_first.recent.page( page_number ).per( items_per_page )

      authorize @memberships
    end

    def search
      authorize Membership

      q = params[:q]
      @memberships = memberships.where( 'date(began_at) = ?', q )
                                .or( memberships.where( 'date(ended_at) = ?', q ) )
                                .recent
                                .page( page_number ).per( items_per_page )

      authorize @memberships if @memberships.present?
      render :index
    end

    def create
      authorize Membership

      if group.add_member( strong_params[ :user_id ] )
        redirect_to group_memberships_path( group ), notice: t( '.success' )
      else
        redirect_to group_memberships_path( group ), alert: t( '.failure' )
      end
    end

    # This marks a membership as ended - it doesn't delete the record of it
    def destroy
      authorize membership

      if membership.end
        redirect_to group_memberships_path( group ), notice: t( '.success' )
      else
        redirect_to group_memberships_path( group ), alert: t( '.failure' )
      end
    end

    # Override the breadcrumbs 'section' link to go back to the groups page
    def breadcrumb_link_text_and_path
      [ t( 'shiny_access.admin.groups.breadcrumb' ), groups_path ]
    end

    private

    def group
      Group.find( params[ :group_id ] )
    end

    def memberships
      group.memberships
    end

    def membership
      memberships.find( params[ :id ] )
    end

    def strong_params
      params.require( :membership ).permit( :user_id )
    end
  end
end
