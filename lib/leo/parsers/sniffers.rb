# frozen_string_literal: true

module Leo # :nodoc:
  module Parsers
    # This class is responsible for parsing node_times.csv, routes.csv and sequences.csv.
    # With the parsed data, it converts the data to corresponding routes.
    # @example
    #   source = Leo::Source.new(:sniffers)
    #   parser = Leo::Parsers::Sniffers.new(source)
    #   parser.routes => [
    #     {
    #         start_node: "alpha",
    #         end_node: "beta",
    #         start_time: "2030-12-31T13:00:01",
    #         end_time: "2030-12-31T13:00:02"
    #     }
    #   ]
    class Sniffers
      attr_reader :source
      # @param [Leo::Source] source Source object
      def initialize(source)
        @source = source
      end

      def routes
        @routes ||= generate_routes
      end

      private

      attr_accessor :node_times, :sequences, :csv_routes

      def parse_node_times
        node_times = Util.parse_csv_file(source.source_path + 'node_times.csv')
        hash = {}
        node_times.each do |item|
          node_time_id, start_node, end_node, duration = item
          hash[node_time_id] = {
            start_node: start_node.strip,
            end_node: end_node.strip,
            duration: duration.to_i / 1000
          }
        end
        self.node_times = hash
      end

      def parse_routes
        routes_array = Util.parse_csv_file(source.source_path + 'routes.csv')
        self.csv_routes = {}
        routes_array.each do |item|
          route_id, time, time_zone = item
          time_with_zone = time + ' ' + time_zone
          csv_routes[route_id] = DateTime.parse(time_with_zone).to_time
        end
        csv_routes
      end

      def parse_sequences
        self.sequences = Util.parse_csv_file(source.source_path + 'sequences.csv')
      end

      def generate_routes
        parse_node_times
        parse_routes
        parse_sequences
        _generate_routes
      end

      def _generate_routes
        routes_list = []
        sequences.each do |seq|
          route_id, node_time_id = seq
          node_time = node_times[node_time_id.strip]
          next unless node_time

          start_time  = csv_routes[route_id]
          end_time    =  start_time + node_time[:duration]
          routes_list << {
            start_node: node_time[:start_node],
            end_node: node_time[:end_node],
            start_time: Util.format_time(start_time),
            end_time: Util.format_time(end_time)
          }
        end
        routes_list
      end
    end
  end
end
