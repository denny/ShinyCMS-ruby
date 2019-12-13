# Top-level pundit policy for admin area
class Admin::DefaultPolicy < DefaultPolicy
  def index?
    return can_list_nil? if @record.nil? || @record.first.nil?

    @this_user.can? :list, @record.first.class.name.to_sym
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
    @this_user.can? :list, calling_class.to_sym
  end

  def show?
    false
  end

  def create?
    @this_user.can? :add, @record.class.name.to_sym
  end

  def new?
    create?
  end

  def update?
    @this_user.can? :edit, @record.class.name.to_sym
  end

  def edit?
    update?
  end

  def delete?
    @this_user.can? :delete, @record.class.name.to_sym
  end
end
