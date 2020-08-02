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
        redirect_to action: :edit, id: @form.id, notice: t( '.success' )
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
        redirect_to action: :edit, id: @form.id, notice: t( '.success' )
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
      @form = Form.find( params[:id] )
    end

    def form_params
      params.fetch( :form, {} )
    end
  end
end
