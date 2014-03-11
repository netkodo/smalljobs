module ApplicationHelper

  # Get the translated select options for
  # the provider contact preferences.
  #
  # @return [Array<String, String>] the preferences
  #
  def provider_contact_preferences
    [
      [I18n.t('contacts.postal'), 'postal'],
      [I18n.t('contacts.phone'), 'phone'],
      [I18n.t('contacts.email'), 'email'],
      [I18n.t('contacts.mobile'), 'mobile']
    ]
  end

  # Get the translated select options for
  # the seeker sex.
  #
  # @return [Array<String, String>] the preferences
  #
  def seeker_sex
    [
      [I18n.t('sex.male'), 'male'],
      [I18n.t('sex.female'), 'female'],
      [I18n.t('sex.other'), 'other']
    ]
  end

  # Get the translated select options for
  # the seeker contact preferences.
  #
  # @return [Array<String, String>] the preferences
  #
  def seeker_contact_preferences
    [
      [I18n.t('contacts.whatsapp'), 'whatsapp'],
      [I18n.t('contacts.mobile'), 'mobile'],
      [I18n.t('contacts.email'), 'email'],
      [I18n.t('contacts.phone'), 'phone']
    ]
  end

  # Get the translated select options for
  # the job date types.
  #
  # @return [Array<String, String>] the date types
  #
  def job_date_types
    [
      [I18n.t('jobs.date_types.agreement'), 'agreement'],
      [I18n.t('jobs.date_types.date'), 'date'],
      [I18n.t('jobs.date_types.date_range'), 'date_range'],
    ]
  end

  # Get the translated select options for
  # the job salary types.
  #
  # @return [Array<String, String>] the salary types
  #
  def job_salary_types
    [
      [I18n.t('jobs.salary_types.hourly'), 'hourly'],
      [I18n.t('jobs.salary_types.fixed'), 'fixed'],
    ]
  end

  # Maps the flash message to a bootstrap alert
  #
  # @param [Symbol] kind the flash type
  # @return [String] the bootstrap class
  #
  def flash_class(kind)
    case kind
    when :notice then 'alert-info'
    when :error then 'alert-error'
    when :alert then 'alert-warning'
    end
  end

  # Get the table bootstrap class depending
  # on the provider status
  #
  # @param [Provider] the provider
  # @return [String] the bootstrap class
  #
  def provider_status_class(provider)
    if !provider.confirmed?
      'warning'
    elsif !provider.active?
      'danger'
    else
      ''
    end
  end

  alias_method :seeker_status_class, :provider_status_class

  # Get the table bootstrap class depending
  # on the job status
  #
  # @param [Job] the job
  # @return [String] the bootstrap class
  #
  def job_status_class(job)
    if job.applications.size == 0
      'warning'
    else
      ''
    end
  end

  # Get the table label depending
  # on the provider status
  #
  # @param [Provider] the provider
  # @return [Array<String>] the label type and text
  #
  def provider_label(provider)
    if !provider.confirmed?
      bootstrap_label('warning', I18n.t('common.unconfirmed'))
    elsif !provider.active?
      bootstrap_label('danger', I18n.t('common.inactive'))
    else
      bootstrap_label('success', I18n.t('common.active'))
    end
  end

  alias_method :seeker_label, :provider_label

  # Get the table label depending
  # on the job status
  #
  # @param [Job] the job
  # @return [Array<String>] the label type and text
  #
  def job_label(job)
    case job.state
    when 'created'
      bootstrap_label('warning', I18n.t('common.created'))
    when 'available'
      bootstrap_label('info', I18n.t('common.available'))
    when 'connected'
      bootstrap_label('primary', I18n.t('common.connected'))
    when 'rated'
      bootstrap_label('success', I18n.t('common.rated'))
    end
  end

  # Creates a bootstrap label
  #
  # @param [Array<String>] label the label type and text
  # @return [String] the label span
  #
  def bootstrap_label(type, text)
    content_tag(:span, text, class: "label label-#{ type }")
  end

  # Test if the given filter is active
  #
  # @param [String] filter the filter query param
  #
  def current_filter_class(filter = '')
    p = params.except(:action, :controller)
    active = p.has_key?(filter) || (filter.empty? && p.empty?)
    active ? 'active' :  nil
  end

end
