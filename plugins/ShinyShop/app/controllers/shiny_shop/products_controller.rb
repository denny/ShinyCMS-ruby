# frozen_string_literal: true

# ShinyShop plugin for ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2025 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyShop
  # Main site controller for shop products - provided by ShinyShop plugin for ShinyCMS
  class ProductsController < ApplicationController
    include ShinyCMS::MainSiteControllerBase

    before_action :check_feature_flags

    def index
      @pagy, @products = pagy( Product.readonly.top_level_products )
    end

    def product_or_section
      @path_parts = params[ :path ].split '/'
      @section = Section.readonly.visible.find_by( slug: @path_parts.last )

      if @section
        section_index
      else
        show
      end
    end

    def section_index
      @pagy, @products = pagy( @section.products.readonly )
      render 'index'
    end

    def show
      if @path_parts.size > 1
        section = Section.readonly.visible.find_by( slug: @path_parts.first )
        raise ActiveRecord::RecordNotFound 'Product not found', Product.new unless section
        @product = section.products.readonly.visible.find_by!( slug: @path_parts.last )
        # TODO: 'Nice' 404 with popular products or something, and a flash 'not found' message
      else
        @product = Product.readonly.visible.find_by!( slug: @path_parts.last )
        # TODO: 'Nice' 404 with popular products or something, and a flash 'not found' message
      end

      if just_purchased?
        confirm_order
      else
        render 'show'
      end
    end

    private

    def just_purchased?
      strong_params[ :session_id ].present?
    end

    # Remove the visible Stripe params from the URL
    def confirm_order
      session = retrieve_stripe_session

      flash[ :notice ] = "Thank you for your order, #{session.customer_details.name}"

      # TODO: deal with path stuff
      redirect_to shiny_shop.product_or_section_path( @product.slug )
    end

    # Handle requests with a single-part path - e.g. /foo
    def show_top_level( slug )
      return if show_top_level_product( slug )
      return if show_top_level_section( slug )

      raise ActiveRecord::RecordNotFound, 'Product not found'
    end

    def show_top_level_product( slug )
      @product = find_top_level_product( slug )
      return unless @product

      show_product
      true
    end

    def show_top_level_section( slug )
      @product = find_top_level_section( slug )&.default_product
      return unless @product

      show_product
      true
    end

    # Handle requests with a multi-part path - e.g. /foo/bar, /foo/bar/baz, etc
    def show_in_section( path_parts )
      slug = path_parts.pop
      section = traverse_path( path_parts, top_level_sections )

      @product = product_for_last_slug( section, slug )
      show_product && return if @product

      raise ActiveRecord::RecordNotFound, 'Product not found'
    end

    # Render the product with the appropriate template
    def show_product
      if @product.template.file_exists?
        render template: "shiny_shop/products/#{@product.template.filename}", locals: @product.elements_hash
      else
        render status: :failed_dependency, inline: I18n.t( 'shiny_shop.products.template_file_missing' )
      end
    end

    # Find the correct section to look for the specified (or default) product in
    def traverse_path( path_parts, sections )
      slug = path_parts.shift
      section = sections&.find_by( slug: slug )

      return section if path_parts.empty? || section.nil?

      traverse_path( path_parts, section.sections )
    end

    def product_for_last_slug( section, slug )
      return if section.blank?

      last_slug_matches_product( section, slug ) || last_slug_matches_section( section, slug )
    end

    def last_slug_matches_product( section, slug )
      return if section.products.blank?

      section.products.with_elements.find_by( slug: slug )
    end

    def last_slug_matches_section( section, slug )
      return if section.sections.blank?

      section.sections.find_by( slug: slug )&.default_product
    end

    def retrieve_stripe_session
      Stripe::Checkout::Session.retrieve( strong_params[ :session_id ] )
    end

    def strong_params
      params.permit( :session_id, :slug )
    end

    def check_feature_flags
      enforce_feature_flags :shop
    end

    def enforce_html_format
      request.format = :html
    end
  end
end
