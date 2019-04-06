module Helpers
  def stub_post_route(request_body:, status: 200, response_body: '')
    stub_request(:post, route_url)
      .with(
        body: request_body,
        headers: { 'Accept' => '*/*' }
      )
      .to_return(status: status, body: response_body, headers: {})
  end

  def route_url(source = nil)
    Leo.route_base + Leo::RouteClient.routes_path(source)
  end

  def sentinels_routes
    [
      { start_node: 'alpha',  end_node: 'beta',   start_time: '2030-12-31T13:00:01', end_time: '2030-12-31T13:00:02' },
      { start_node: 'beta',   end_node: 'gamma',  start_time: '2030-12-31T13:00:02', end_time: '2030-12-31T13:00:03' },
      { start_node: 'delta',  end_node: 'beta',   start_time: '2030-12-31T13:00:02', end_time: '2030-12-31T13:00:03' },
      { start_node: 'beta',   end_node: 'gamma',  start_time: '2030-12-31T13:00:03', end_time: '2030-12-31T13:00:04' }
    ]
  end

  def sniffers_routes
    [
      { start_node: 'lambda', end_node: 'tau',    start_time: '2030-12-31T13:00:06', end_time: '2030-12-31T13:00:07' },
      { start_node: 'tau',    end_node: 'psi',    start_time: '2030-12-31T13:00:06', end_time: '2030-12-31T13:00:07' },
      { start_node: 'psi',    end_node: 'omega',  start_time: '2030-12-31T13:00:06', end_time: '2030-12-31T13:00:07' },
      { start_node: 'lambda', end_node: 'psi',    start_time: '2030-12-31T13:00:07', end_time: '2030-12-31T13:00:08' },
      { start_node: 'psi',    end_node: 'omega',  start_time: '2030-12-31T13:00:07', end_time: '2030-12-31T13:00:08' }
    ]
  end
end

RSpec.configure do |config|
  config.include Helpers
end
