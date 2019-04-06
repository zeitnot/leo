# frozen_string_literal: true

module Leo # :nodoc:
  module Parsers
    # This class is responsible for parsing routes.csv and converting the data to corresponding routes.
    # @example
    #   source = Leo::Source.new(:sentinels)
    #   parser = Leo::Parsers::Sentinels.new(source)
    #   parser.routes => [
    #     {
    #         start_node: "alpha",
    #         end_node: "beta",
    #         start_time: "2030-12-31T13:00:01",
    #         end_time: "2030-12-31T13:00:02"
    #     }
    #   ]
    class Sentinels < Base
      private

      # :reek:FeatureEnvy
      def generate_routes
        output = []
        array = from_csv_to_array
        array.each_with_index do |item, seq|
          _, node, index, time = item
          index = index.to_i
          next if index == 2

          next_item = array[seq + 1]
          output << {
            start_node: node.delete(' '),
            end_node: next_item[1].delete(' '),
            start_time: Util.format_time(time),
            end_time: Util.format_time(next_item[3])
          }
        end
        output
      end

      def from_csv_to_array
        data = File.read(source.source_path + 'routes.csv')
        data.delete!('"')
        array = CSV.parse(data, col_sep: ',')

        # Remove headers
        # Remove Zeta
        array[1..-2]
      end
    end
  end
end
