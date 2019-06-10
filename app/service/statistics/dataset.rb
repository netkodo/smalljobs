module Statistics
  class Dataset
    attr_reader :data, :color, :name

    def initialize data, color, name
      @data = data
      @color = color
      @name = name
    end

    def call
      create_dataset
    end

    private

    def create_dataset
      dataset = data.map{|single_data| {x: single_data['date_interval'].to_date.strftime("%Y-%m-%d"), y: single_data['records_number']}}
      {
        label: name,
        fill: false,
        pointRadius: 3,
        lineTension: 0.1,
        borderWidth: 2,
        borderColor: [
          color
        ],
        backgroundColor: [
          color
        ],
        pointBackgroundColor: color,
        data: dataset
      }
    end
  end
end