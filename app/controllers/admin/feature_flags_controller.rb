# Admin controller for feature flags
class Admin::FeatureFlagsController < AdminController
  after_action :verify_authorized

  def index
    @flags = FeatureFlag.all.order( :name )
    authorise @flags
  end

  def update
    authorise FeatureFlag

    if FeatureFlag.update_all_flags( feature_flag_params )
      flash[ :notice ] = t( '.success' )
    else
      flash[ :alert  ] = t( '.failure' )
    end
    redirect_to action: :index
  end

  private

  def feature_flag_params
    params.require( :features ).permit( flags: {} )
  end
end
