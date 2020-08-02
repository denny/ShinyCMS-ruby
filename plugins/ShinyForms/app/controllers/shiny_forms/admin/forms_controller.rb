# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # ShinyForms plugin admin controller - add/edit/delete form handlers
  class Admin::FormsController < AdminController
    before_action :set_form, only: %i[ edit update destroy ]

    # GET /admin/forms
    def index
      authorise Form
      page_num = params[ :page ] || 1
      @forms = Form.page( page_num )
      authorise @forms if @forms.present?
    end

    # GET /admin/forms/new
    def new
      @form = Form.new
      authorise @form
    end

    # POST /admin/forms
    def create
      @form = Form.new(form_params)
      authorise @form

      if @form.save
        flash[ :notice ] = t( '.success' )
        redirect_to action: :edit, id: @form.id
      else
        flash.now[ :alert ] = t( '.failure' )
        render :new
      end
    end

    # GET /admin/forms/1
    def edit
      authorise @form
    end

    # PATCH/PUT /admin/forms/1
    def update
      authorise @form

      if @form.update(form_params)
        flash[ :notice ] = t( '.success' )
        redirect_to action: :edit, id: @form.id
      else
        flash.now[ :alert ] = t( '.failure' )
        render :edit
      end
    end

    # DELETE /admin/forms/1
    def destroy
      authorise @form

      @form.destroy!
      redirect_to forms_path, notice: t( '.success' )
    end

    private

    def set_form
      @form = ShinyForms::Form.find( params[:id] )
    rescue ActiveRecord::RecordNotFound
      skip_authorization
      redirect_with_alert forms_path, t( '.failure' )
    end

    def form_params
      params.require( :form ).permit(
        :internal_name, :public_name, :slug, :handler
      )
    end
  end
end
