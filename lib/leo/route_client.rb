# frozen_string_literal: true

module Leo # :nodoc:
  # <code>RouteClient</code> executes request against <code>challenge.distribusion.com</code> and allows a client both
  # to download zip files and to post routes.
  class RouteClient
    class << self
      # Downloads zip file from <code>/the_one/routes</code> path.
      # @param [String,Symbol] source This value would be <code>sentinels</code>,
      #   <code>sniffers</code> and <code>loopholes</code>
      # @return [Faraday::Response, nil] Returns nil in case of connection problems
      def get_routes(source)
        with_rescue do
          connection.get do |request|
            request.url routes_path(source.to_s)
          end
        end
      end

      # Posts a route to <code>/the_one/routes</code> path with given payload.
      # @param [String,Hash] payload The value would be a valid JSON string or a Hash.
      # @return [Faraday::Response, nil] Returns nil in case of connection problems
      def post_route(payload)
        with_rescue do
          payload = payload.to_json if payload.is_a?(Hash)
          connection.post do |request|
            request.url routes_path
            request.body = payload
            request.headers['Content-Type'] = 'application/json'
          end
        end
      end

      # Creates a Faraday connection instance for <code>challenge.distribusion.com</code>.
      # @return [Faraday::Connection]
      def connection
        @connection ||= Faraday.new(url: Leo.route_base) do |faraday|
          faraday.options.timeout       = Leo.read_timeout
          faraday.options.open_timeout  = Leo.open_timeout
          faraday.use                     Faraday::Response::RaiseError
          faraday.request                 :url_encoded
          faraday.adapter                 Faraday.default_adapter
        end
      end

      #  This is a helper method to build the path for both getting and posting routes.
      # @example
      #   Leo::RouteClient.routes_path('sentinels') => '/the_one/routes?source=sentinels'
      # @param [String] source
      # @return [String]
      def routes_path(source = nil)
        path = '/the_one/routes'
        path += '?' + URI.encode_www_form(source: source, passphrase: Leo.passphrase) if source
        path
      end

      # Decides whether to retry the failed request or not.
      def retry?(exception, num_retries)
        return false if num_retries >= Leo.max_network_retries

        # Retry on timeout-related problems (either on open or read).
        return true if exception.is_a?(Faraday::TimeoutError)

        # Destination refused the connection, the connection was reset, or a
        # variety of other connection failures.
        return true if exception.is_a?(Faraday::ConnectionFailed)

        if exception.is_a?(Faraday::ClientError)
          response = exception.response
          # 409 conflict
          return true if response && response[:status] == 409
        end

        false
      end

      def with_rescue
        retry_count = 0
        begin
          yield
        rescue StandardError => exception
          retry_count += 1
          retry if retry?(exception, retry_count)
          raise unless exception.is_a?(Faraday::ClientError)
        end
      end
    end
  end
end
