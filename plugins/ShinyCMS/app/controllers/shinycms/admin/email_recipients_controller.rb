# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2021 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

module ShinyCMS
  # Controller for main site email-recipient features in ShinyCMS
  class Admin::EmailRecipientsController < AdminController
    helper_method :pagy_url_for

    def index
      authorize EmailRecipient
      @pagy, @recipients = pagy( EmailRecipient.order( updated_at: :desc ), items: items_per_page )
      authorize @recipients
    end

    def search
      authorize EmailRecipient

      @pagy, @recipients = pagy( EmailRecipient.admin_search( params[:q] ), items: items_per_page )

      authorize @recipients if @recipients.present?
      render :index
    end

    def do_not_contact
      authorize EmailRecipient
      recipient = EmailRecipient.find( params[ :id ] )
      authorize recipient

      flash[ :notice ] = t( '.success' ) if recipient && DoNotContact.add( recipient.email )

      redirect_to email_recipients_path
    end

    def destroy
      authorize EmailRecipient
      recipient = EmailRecipient.find( params[ :id ] )
      authorize recipient

      flash[ :notice ] = t( '.success' ) if recipient.destroy

      redirect_to email_recipients_path
    end

    # Override pager link format (to admin/action/page/NN rather than admin/action?page=NN)
    def pagy_url_for( page, _pagy )
      params = request.query_parameters.merge( only_path: true, page: page )
      url_for( params )
    end
  end
end
