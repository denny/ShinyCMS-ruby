# Helper methods for admin area
module AdminAreaHelper
  def authorise( record )
    record_class_name = class_name( record )
    policy_class_name = "Admin::#{record_class_name}Policy"

    authorize record, policy_class: policy_class_name.constantize
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
