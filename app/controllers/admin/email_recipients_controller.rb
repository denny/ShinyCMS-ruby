# frozen_string_literal: true

# ShinyCMS ~ https://shinycms.org
#
# Copyright 2009-2020 Denny de la Haye ~ https://denny.me
#
# ShinyCMS is free software; you can redistribute it and/or modify it under the terms of the GPL (version 2 or later)

# Controller for main site email-recipient features in ShinyCMS
class Admin::EmailRecipientsController < AdminController
  def index
    authorize EmailRecipient
    @recipients = EmailRecipient.page( page_number ).per( items_per_page )
    authorize @recipients
  end

  def search
    authorize EmailRecipient

    q = params[:q]
    @recipients = EmailRecipient.where( 'email ilike ?', "%#{q}%" )
                                .or( EmailRecipient.where( 'name ilike ?', "%#{q}%" ) )
                                .order( updated_at: :desc )
                                .page( page_number ).per( items_per_page )

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
end
