module Helpers
  def stub_post_route(request_body:, status: 200, response_body: '')
    stub_request(:post, route_url).
        with(
            body: request_body,
            headers: { 'Accept' => '*/*' }).
        to_return(status: status, body: response_body, headers: {})
  end

  def route_url(source=nil)
    Leo.route_base + Leo::RouteClient.routes_path(source)
  end
end

RSpec.configure do |config|
  config.include Helpers
end