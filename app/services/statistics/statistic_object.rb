module Statistics
  class StatisticObject

    attr_accessor :organization, :options, :date_range

    def initialize(date_range, organization, options)
      @organization = organization
      @date_range = date_range
      @options = options
    end

    def call
      get_grouped_data
    end

    def get_summed_records records_array
      rec_arr = records_array.to_a
      records_array = []
      rec_arr.each_with_index.map do |x, y|
        records_array << {
            'date_interval' => x['date_interval'],
            'records_number' => rec_arr[0..y].sum{|s| s['records_number']},
        }
      end
      records_array
    end

    def format_array(records_array)
      if options[:interval] == 'year'
        records_array.each{|record| record['date_interval'] = record['date_interval'].to_date.strftime("%Y")}
      elsif options[:interval] == 'month'
        records_array.each{|record| record['date_interval'] = record['date_interval'].to_date.strftime("%Y-%m")}
      else
        records_array.each{|record| record['date_interval'] = record['date_interval'].to_date.strftime("%Y-%m-%d")}
      end
      records_array
    end

  end
end

