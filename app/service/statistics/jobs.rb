module Statistics
  class Jobs

    attr_accessor :organization, :interval, :date_range

    def initialize(date_range, interval, organization)
      @organization = organization
      @interval = interval
      @date_range = date_range
    end

    def call
      get_grouped_data
    end

    def get_grouped_data
      sql = "
        SELECT date_trunc('#{interval}', created_at) AS \"date_interval\" , count(*) AS \"records_number\"
        FROM jobs
        WHERE created_at BETWEEN '#{date_range[0]}' AND '#{date_range[-1]}'
        GROUP BY 1
        ORDER BY 1;
      "
      records_array = ActiveRecord::Base.connection.execute(sql)
      Statistics::Dataset.new(records_array, 'rgba(0,0,255,1)', 'Job').call
    end
  end
end