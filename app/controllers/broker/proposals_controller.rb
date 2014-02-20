class Broker::ProposalsController < InheritedResources::Base

  before_filter :authenticate_broker!

  load_and_authorize_resource :job, through: :current_region
  load_and_authorize_resource :proposal, through: :job
  skip_authorize_resource :proposal, only: :new

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(proposal: [:id, :provider_id, :seeker_id, :message])
  end
end,gfroutes,gfroutes
