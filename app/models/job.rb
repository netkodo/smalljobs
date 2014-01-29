class Job < ActiveRecord::Base
  has_and_belongs_to_many :seekers

  belongs_to :provider, inverse_of: :jobs
  belongs_to :work_category, inverse_of: :jobs

  has_one :place, through: :provider

  validates :provider, presence: true
  validates :work_category, presence: true

  validates :state, presence: true, inclusion: { in: lambda { |m| m.state_enum }}

  validates :title, presence: true
  validates :description, presence: true

  validates :date_type, presence: true, inclusion: { in: lambda { |m| m.date_type_enum }}
  validates :start_date, presence: true, if: lambda { |m| ['date', 'date_range'].include?(m.date_type) }
  validates :end_date, presence: true, if: lambda { |m| m.date_type == 'date_range' }

  validates :salary, presence: true, numericality: true
  validates :salary_type, presence: true, inclusion: { in: lambda { |m| m.salary_type_enum }}

  validates :manpower, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 1
  }

  validates :duration, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 30
  }

  # Available date types
  #
  # @return [Array<String>] list of possible dates types
  #
  def date_type_enum
    %w(agreement date date_range)
  end

  # Available status types
  #
  # @return [Array<String>] list of possible job states
  #
  def state_enum
    %w(created available connected rated)
  end

  # Available salary types
  #
  # @return [Array<String>] list of possible salary types
  #
  def salary_type_enum
    %w(hourly fixed)
  end
end
