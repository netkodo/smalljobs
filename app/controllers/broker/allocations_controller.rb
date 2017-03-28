class Broker::AllocationsController < InheritedResources::Base

  before_filter :authenticate_broker!

  belongs_to :job

  # load_and_authorize_resource :job
  # load_and_authorize_resource :allocation, through: :job

  skip_authorize_resource :allocation, only: :new

  actions :all

  def show
    @job = Job.find_by(id: params[:job_id])
    if params[:seeker_id] != nil
      @allocation = Allocation.where(job_id: @job.id, seeker_id: params[:seeker_id]).proposal.first
      if @allocation == nil
        @allocation = Allocation.new(job_id: @job.id, seeker_id: params[:seeker_id], state: :proposal)
        @allocation.save!
      end
    else
      @allocation = Allocation.find_by(id: params[:id])
    end

    require 'rest-client'
    if @allocation.conversation_id != nil
      response = RestClient.get "https://devadmin.jugendarbeit.digital/api/jugendinfo_message/get_messages/?key=ULv8r9J7Hqc7n2B8qYmfQewzerhV9p&id=#{@allocation.conversation_id}"
      json = JSON.parse(response.body)
      @messages = json['messages']
    else
      @messages = []
    end
  end

  def change_state
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])

    if @allocation.application_open?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.application_rejected?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.proposal?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.active?
      @allocation.state = :finished
      @allocation.save!
    elsif @allocation.finished?
      @allocation.state = :active
      @allocation.save!
    elsif @allocation.cancelled?
      @allocation.state = :active
      @allocation.save!
    end

    render json: {redirect_to: broker_job_allocation_url(@job, @allocation)}

  end

  def cancel_state
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])

    redirect_to = broker_job_allocation_url(@job, @allocation)

    if @allocation.application_open?
      @allocation.state = :rejected
      @allocation.save!
    elsif @allocation.proposal?
      @allocation.destroy!
      redirect_to = broker_dashboard_path
    elsif @allocation.active?
      @allocation.state = :cancelled
      @allocation.save!
    end

    render json: {redirect_to: redirect_to}
  end

  def send_message
    @job = Job.find_by(id: params[:job_id])
    @allocation = Allocation.find_by(id: params[:id])
    seeker = @allocation.seeker
    title = params[:title]
    message = params[:message]
    require 'rest-client'
    dev = "https://devadmin.jugendarbeit.digital/api/jugendinfo_push/send"
    live = "https://admin.jugendarbeit.digital/api/jugendinfo_push/send"
    response = RestClient.post dev, {api: 'ULv8r9J7Hqc7n2B8qYmfQewzerhV9p', message_title: title, message: message, device_token: seeker.app_user_id, sendermail: current_broker.email}
    json = JSON.parse(response.body)
    conv_id = json['conversation_id']
    @allocation.conversation_id = conv_id
    @allocation.save!

    render json: {state: 'ok'}
  end

  protected

  def current_user
    current_broker
  end

  def permitted_params
    params.permit(allocation: [:id, :job_id, :seeker_id, :state, :feedback_seeker, :feedback_provider, :contract_returned])
  end
end
