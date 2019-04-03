require 'faraday'

module Leo
  # <code>RouteClient</code> executes request against <code>challenge.distribusion.com</code> and allows a client both
  # to download zip files and to post routes.
  class RouteClient
    class << self

      # Downloads zip file from <code>/the_one/routes</code> path.
      # @param [String] source This value would be <code>sentinels</code>, <code>sniffers</code> and <code>loopholes</code>
      # @return [Faraday::Response]
      def get_routes(source)
        connection.get do |request|
          request.url routes_path(source)
        end
      end

      # Posts a route to <code>/the_one/routes</code> path with given payload.
      # @param [String,Hash] payload The value would be a valid JSON string or a Hash.
      # @return [Faraday::Response]
      def post_route(payload)
        payload = payload.to_json if payload.is_a?(Hash)
        connection.post do |request|
          request.url routes_path
          request.body = payload
          request.headers['Content-Type'] = 'application/json'
        end
      end
      # Creates a Faraday connection instance for <code>challenge.distribusion.com</code>.
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(url: Leo.route_base) do |faraday|
          faraday.request  :url_encoded
          faraday.adapter  Faraday.default_adapter
        end
      end

      #  This is a helper method to build the path for both getting and posting routes.
      # @example
      #   Leo::RouteClient.routes_path('sentinels') => '/the_one/routes?source=sentinels'
      # @param [String] source
      # @return [String]
      def routes_path(source=nil)
        path = '/the_one/routes'
        path << '?source=' << source if source
        path
      end

    end
  end
end