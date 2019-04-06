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
        routes_array = parse_routes
        routes_array.map.with_index do |item, seq|
          _, node, index, time = item
          index = index.to_i
          next if index == 2

          next_item = routes_array[seq + 1]
          {
            start_node: node.delete(' '),
            end_node: next_item[1].delete(' '),
            start_time: Util.format_time(time),
            end_time: Util.format_time(next_item[3])
          }
        end.compact
      end

      def parse_routes
        array = Util.parse_csv_file(source.source_path + 'routes.csv')
        array[0..-2] # Remove Zeta
      end
    end
  end
end
