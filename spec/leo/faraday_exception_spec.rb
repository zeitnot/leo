RSpec.describe 'Faraday Exceptions' do

  context 'client specific errors' do
    context 'and response status is 40x' do
      it 'fails silently' do
        source = :sentinels
        stub_request(:get, route_url(source))
            .with(headers: { 'Accept' => '*/*' })
            .to_return(status: 422, body: '', headers: {})

        stub_post_route( request_body: '', status: 422 )

        expect(Leo::RouteClient.get_routes(source)).to be_nil
        expect(Leo::RouteClient.post_route('')).to be_nil
      end
    end

    context 'and response status is 50x' do
      it 'fails silently' do
        source = :sentinels
        stub_request(:get, route_url(source))
            .with(headers: { 'Accept' => '*/*' })
            .to_return(status: 503, body: '', headers: {})

        stub_post_route( request_body: '', status: 503 )

        expect(Leo::RouteClient.get_routes(source)).to be_nil
        expect(Leo::RouteClient.post_route('')).to be_nil
      end
    end
  end

  context 'network specific errors' do
    context 'and it is Faraday::TimeoutError' do
      it 'fails silently' do
        exception_class = Faraday::TimeoutError
        allow(Leo::RouteClient.connection).to receive(:get).and_raise(exception_class)
        expect(Leo::RouteClient.get_routes('')).to be_nil

        allow(Leo::RouteClient.connection).to receive(:post).and_raise(exception_class)
        expect(Leo::RouteClient.post_route('')).to be_nil
      end
    end

    context 'and it is Faraday::ConnectionFailed' do
      xit 'fails silently' do
        exception_class = Faraday::ClientError
        allow(Leo::RouteClient.connection).to receive(:get).and_raise(exception_class)
        expect(Leo::RouteClient.get_routes('')).to be_nil

        allow(Leo::RouteClient.connection).to receive(:post).and_raise(exception_class)
        expect(Leo::RouteClient.post_route('')).to be_nil
      end
    end

    context 'and it is unknown exception' do
      it 'raises exception and terminates the program' do
        exception_class = ZeroDivisionError
        allow(Leo::RouteClient.connection).to receive(:get).and_raise(exception_class)
        expect{ Leo::RouteClient.get_routes('') }.to raise_error(exception_class)

        allow(Leo::RouteClient.connection).to receive(:post).and_raise(exception_class)
        expect{ Leo::RouteClient.post_route('') }.to raise_error(exception_class)
      end
    end
  end
end