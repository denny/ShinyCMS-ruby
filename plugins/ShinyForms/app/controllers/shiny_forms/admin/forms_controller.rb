# frozen_string_literal: true

require_dependency 'shiny_forms/application_controller'

module ShinyForms
  # Provides useful generic endpoints to post a form to
  class Admin::FormsController < ApplicationController
    before_action :set_form, only: %i[ show edit update destroy ]

    # GET /admin/forms
    def index
      @forms = Form.all
    end

    # GET /admin/forms/new
    def new
      @form = Form.new
    end

    # GET /admin/forms/1
    def edit; end

    # POST /admin/forms
    def create
      @form = Form.new(form_params)

      if @form.save
        redirect_to @form, notice: 'Form was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /admin/forms/1
    def update
      if @form.update(form_params)
        redirect_to @form, notice: 'Form was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /admin/forms/1
    def destroy
      @form.destroy!
      redirect_to forms_url, notice: 'Form was successfully destroyed.'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def form_params
      params.fetch(:form, {})
    end
  end
end
