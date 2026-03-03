# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2026 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Concern for user authorization - powered by Pundit
  module ShinyUserAuthorization
    extend ActiveSupport::Concern

    included do
      # Associations

      has_many :user_capabilities, dependent: :destroy
      has_many :capabilities, through: :user_capabilities, inverse_of: :users

      # Instance methods

      def admin?
        general = CapabilityCategory.find_by( name: 'general' )
        capabilities.exists? name: 'view_admin_area', category: general
      end

      def not_admin?
        !admin?
      end

      def can?( capability_name, category_name = :general )
        return cached_can?( capability_name, category_name ) if @cached_capabilities.present?

        cc = CapabilityCategory.find_by( name: category_name.to_s )
        return true if capabilities.exists? name: capability_name.to_s, category: cc

        false
      end

      def cached_can?( capability, category = :general )
        return false if cached_capabilities.blank?

        return true if cached_capabilities[ category.to_s ]&.include? capability.to_s

        false
      end

      def cached_capabilities
        return @cached_capabilities if @cached_capabilities.present?

        @cached_capabilities =
          capabilities.joins( :category )
                      .pluck( 'shinycms_capability_categories.name', :name )
                      .group_by( &:shift )
                      .each_value( &:flatten! )
      end

      def cache_capabilities
        cached_capabilities if @cached_capabilities.blank?
        self
      end

      def capabilities=( capability_set )
        old_capabilities = user_capabilities.pluck( :capability_id ).sort
        new_capabilities = capability_set.keys.collect( &:to_i ).sort

        remove = old_capabilities - new_capabilities
        add    = new_capabilities - old_capabilities

        add.each do |capability_id|
          user_capabilities.create!( capability_id: capability_id )
        end

        user_capabilities.where( capability_id: remove ).delete_all
      end
    end

    class_methods do
      # Return all users that have the specified capability
      def that_can( capability, category = nil )
        category ||= 'general'
        ShinyCMS::Capability
          .find_by( capability: capability.to_s, category: category.to_s )
          .user_capabilities.collect( &:user )
      end

      # Check whether we have at least one admin who can create more admins
      def super_admins_exist?
        that_can( :add, :admin_users ).present?
      end
    end
  end
end
