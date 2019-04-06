# frozen_string_literal: true

module Leo
  module Parsers
    class Base # :nodoc:
      attr_reader :source
      # @param [Leo::Source] source Source object
      def initialize(source)
        @source = source
      end

      def routes
        @routes ||= generate_routes
      end

      private

      def generate_routes
        raise MethodNotImplementedError, 'generate_routes method is not implemented.'
      end
    end
  end
end
