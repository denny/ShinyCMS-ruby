# Helper methods for admin area
module AdminAreaHelper
  # Invoke Pundit
  def authorise( record )
    record_class_name = class_name( record )
    policy_class_name = "Admin::#{record_class_name}Policy"

    authorize record, policy_class: policy_class_name.constantize
  end

  # Return true if the page we're on might need a WYSIWYG HTML editor
  def html_editor_needed?
    controller_name == 'shared_content' ||
      ( controller_name =~ /^blog/ && %w[ new edit ].include?( action_name )) ||
      ( controller_name =~ /^page/ && %w[     edit ].include?( action_name ) )
  end

  def redirect_with_alert( redirect_path, alert_message )
    skip_authorization
    redirect_to redirect_path, alert: alert_message
  end

  def render_capability_checkbox( form, capability, capability_category )
    render partial: 'capability_checkbox', locals: {
      f: form,
      capability: capability,
      category: capability_category
    }
  end

  def render_admin_menu_section_start( text, icon = nil )
    render partial: 'admin/menu/menu__section_start',
           locals: { text: text, icon: icon }
  end

  def render_admin_menu_item( text, link, icon = nil )
    render partial: 'admin/menu/menu__item',
           locals: { text: text, link: link, icon: icon }
  end

  def render_admin_menu_item_if( condition, text, link, icon = nil )
    return unless condition

    render partial: 'admin/menu/menu__item',
           locals: { text: text, link: link, icon: icon }
  end

  def render_admin_menu_section_end
    render partial: 'admin/menu/menu__section_end'
  end

  private

  def class_name( this )
    return this.first.class.name if this.class.name == 'ActiveRecord::Relation'
    return this.first.class.name if this.class.name == 'Array'
    return this.name             if this.class.name == 'Class'
    return this.to_s.classify    if this.class.name == 'Symbol'

    this.class.name
  end
end
