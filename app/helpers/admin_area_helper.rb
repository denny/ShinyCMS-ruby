# frozen_string_literal: true

# Helper methods for admin area
module AdminAreaHelper
  # Invoke Pundit
  def authorise( record )
    if record.is_a? Symbol
      policy_class_name = "Admin::#{record.to_s.camelize}Policy"
    elsif record.respond_to? :policy_class
      policy_class_name = record.policy_class.to_s
    else
      record_class_name = class_name( record )
      record_class_name = record_class_name.remove( '::' )
      policy_class_name = "Admin::#{record_class_name}Policy"
    end

    authorize record, policy_class: policy_class_name.constantize
  end

  # Return true if the page we're on might need a WYSIWYG HTML editor
  def html_editor_needed?
    controller_name == 'inserts' ||
      ( action_name == 'new'  && controller_name == 'posts' ) ||
      ( action_name == 'edit' &&
        %w[ posts pages templates ].include?( controller_name ) )
  end

  def plugins_for_admin_menu
    ::Plugin.with_template( 'admin/menu/_section.html.erb' )
  end

  def render_capability_category( form, category, capabilities, show )
    render partial: 'capability_category', locals: {
      f: form,
      category: category,
      category_capabilities: capabilities,
      show: show
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

  def render_admin_menu_section( text, icon = nil, &contents )
    section = render_admin_menu_section_start( text, icon )
    section << capture do
      contents.call
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
