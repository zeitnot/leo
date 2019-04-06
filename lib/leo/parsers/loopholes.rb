# frozen_string_literal: true

module Leo # :nodoc:
  module Parsers
    # This class is responsible for parsing node_pairs.json, routes.json and converts them routes.
    # @example
    #   source = Leo::Source.new(:loopholes)
    #   parser = Leo::Parsers::Loopholes.new(source)
    #   parser.routes => [
    #     {
    #         start_node: "alpha",
    #         end_node: "beta",
    #         start_time: "2030-12-31T13:00:01",
    #         end_time: "2030-12-31T13:00:02"
    #     }
    #   ]
    class Loopholes
      attr_reader :source
      # @param [Leo::Source] source Source object
      def initialize(source)
        @source = source
      end

      def routes
        @routes ||= generate_routes
      end

      private

      attr_accessor :node_pairs, :json_routes

      def generate_routes
        parse_node_pairs
        parse_json_routes
        json_routes.map do |route|
          node_pair = node_pairs[route['node_pair_id']]
          next unless node_pair

          {
            start_node: node_pair['start_node'],
            end_node: node_pair['end_node'],
            start_time: Util.format_time(route['start_time']),
            end_time: Util.format_time(route['end_time'])
          }
        end.compact
      end

      def parse_node_pairs
        pairs = Util.parse_json_file(source.source_path + 'node_pairs.json')['node_pairs']
        self.node_pairs = pairs.each_with_object({}) { |item, hash| hash[item['id']] = item }
      end

      def parse_json_routes
        self.json_routes = Util.parse_json_file(source.source_path + 'routes.json')['routes']
      end
    end
  end
end
