module Statistics
  class Seekers

    attr_accessor :organization, :interval, :date_range

    def initialize(date_range, interval, organization)
      @organization = organization
      @interval = interval
      @date_range = date_range
    end

    def call
      get_grouped_data
    end

    def organization_ids
      jobs = "(#{organization.join(',')})"
      return "organization_id IN #{jobs}"
    end

    def get_grouped_data
      sql = "
        SELECT date_trunc('#{interval}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM seekers
        WHERE created_at BETWEEN '#{date_range[0]}' AND '#{date_range[-1]}' AND #{organization_ids}
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      Statistics::Dataset.new(records_array, 'rgba(255,99,132,1)', 'Seekers').call
    end
  end
end