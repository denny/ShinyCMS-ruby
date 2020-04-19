# Helper methods for admin area
module AdminAreaHelper
  # Invoke Pundit
  def authorise( record )
    record_class_name = class_name( record )
    record_class_name.remove!( '::' )
    policy_class_name = "Admin::#{record_class_name}Policy"

    authorize record, policy_class: policy_class_name.constantize
  end

  # Return true if the page we're on might need a WYSIWYG HTML editor
  def html_editor_needed?
    controller_name == 'inserts' ||
      ( action_name == 'new'  && controller_name == 'posts' ) ||
      ( action_name == 'edit' &&
        %w[ posts pages templates ].include?( controller_name ) )
  end

  def redirect_with_alert( redirect_path, alert_message )
    skip_authorization
    flash[ :alert ] = alert_message
    redirect_to redirect_path
  end

  def render_capability_category( form, category, capblts, show, skip = false )
    render partial: 'capability_category', locals: {
      f: form,
      category: category,
      category_capabilities: capblts,
      show: show,
      skip_name: skip
    }
  end

  def render_capability_checkbox( form, capability, capability_category )
    return if capability == 'skip'

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

  def render_admin_menu_section_end
    render partial: 'admin/menu/menu__section_end'
  end

  def render_admin_menu_section( text, icon = nil )
    section = render_admin_menu_section_start( text, icon )
    section << capture do
      yield
    end
    section << render_admin_menu_section_end
  end

  def render_admin_menu_item( text, link, icon = nil )
    render partial: 'admin/menu/menu__item',
           locals: { text: text, link: link, icon: icon }
  end

  def render_admin_menu_item_if( condition, text, link, icon = nil )
    render_admin_menu_item( text, link, icon ) if condition
  end

  private

  def class_name( this )
    return this.first.class.name if this.class.name == 'ActiveRecord::Relation'
    return this.first.class.name if this.class.name == 'Array'
    return this.name             if this.class.name == 'Class'
    return this.name             if this.class.name == 'Module'
    return this.to_s.classify    if this.class.name == 'Symbol'

    this.class.name
  end
end
