# frozen_string_literal: true

module Leo
  # This class is responsible for consolidating all available routes for given source and posts those routes to
  # <code>challenge.distribusion.com</code> server.
  class PostManager
    attr_reader :sources, :failed_routes
    # @param [Array] args
    #   <code>Leo::PostManager.new</code>  means all sources will be posted.
    #   <code>Leo::PostManager.new :sentinels, :sniffers</code>  Only sentinels and sniffers sources will be posted.
    def initialize(*args)
      @sources        = args.any? ? args.map(&:to_sym).uniq : Leo::SOURCES
      @failed_routes  = {}
    end

    # Consolidates source's routes
    # @return [Hash]
    def routes
      @routes ||= sources.each_with_object({}) do |source, hash|
        source_object = Source.new(source)
        hash[source] = source_object.routes
      end
    end

    # Posts routes that are returned from <code>routes</code> method to <code>challenge.distribusion.com</code> server
    # @see https://challenge.distribusion.com/the_one/red_pill
    # @return [#failed_routes] If the returned hash is empty this means all routes are
    #   posted. If the returned value something like this <code>{['sentinels', 'beta', 'gamma'] => true }</code>;
    #   this means, from sentinels source <code>beta</code> -> <code>gamma</code> route is not posted.
    def post_routes
      routes.each do |source, routes|
        Leo.logger.info "Begin posting #{source} routes..."
        routes.each do |route|
          response = RouteClient.post_route(route.merge(source: source, passphrase: Leo.passphrase))
          log_string = "#{source}: #{route[:start_node]} -> #{route[:end_node]}"
          if response.status == 201
            Leo.logger.info "#{log_string} is uploaded."
          else
            failed_routes[[source, route[:start_node], route[:end_node]]] ||= true
            Leo.logger.error "#{log_string} is not uploaded."
          end
        end
        Leo.logger.info "End posting #{source} routes.\n"
      end
      failed_routes
    end
  end
end
