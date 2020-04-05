# Mailer for Devise-powered user account emails (password reset, etc)
class UserMailer < Devise::Mailer
  before_action :set_site_name

  def registration( user )
    @resource = user

    mail(
      to: user.email,
      subject: t( '.subject' ),
      template_path: 'shinycms/devise/mailer'
    ) do |format|
      format.mjml
      format.text
    end
  end

  private

  def set_site_name
    @site_name = I18n.t( 'site_name' )
  end
end
