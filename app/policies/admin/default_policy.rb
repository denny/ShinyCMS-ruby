# frozen_string_literal: true

# Top-level pundit policy for admin area
class Admin::DefaultPolicy < DefaultPolicy
  def index?
    return can_list_nil? unless @record.class.method_defined?( :first ) && @record.first.present?

    @this_user.can? :list, CapabilityCategory.name_for( @record.first )
  end

  # Handle the case where a list page has no content yet
  def can_list_nil?
    calling_class = self.class.ancestors[0].to_s
    calling_class.remove! 'Admin::'
    calling_class.remove! 'Policy'
    Rails.logger.debug <<~LOG
      [ShinyCMS] A nil @record was passed to authorise()
      [ShinyCMS] (this probably just means that there's nothing to list yet)
      [ShinyCMS] Making best guess and checking auth for #{calling_class}
    LOG
    @this_user.can? :list, CapabilityCategory.name_for( calling_class.constantize )
  end

  def create?
    @this_user.can? :add, CapabilityCategory.name_for( @record )
  end

  def new?
    create?
  end

  def update?
    @this_user.can? :edit, CapabilityCategory.name_for( @record )
  end

  def edit?
    update?
  end

  def destroy?
    @this_user.can? :destroy, CapabilityCategory.name_for( @record )
  end
end
