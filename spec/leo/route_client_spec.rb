RSpec.describe Leo::RouteClient do
  subject { Leo::RouteClient }

  describe '.connection' do
    it 'returns Faraday::Connection object' do
      expect(subject.connection).to be_kind_of(Faraday::Connection)
    end

    it 'responds to get method' do
      expect(subject.connection).to be_respond_to(:get)
    end

    it 'responds to post method' do
      expect(subject.connection).to be_respond_to(:post)
    end
  end

  describe '.get_routes' do
    let(:source) { 'sentinels' }

    before do
      stub_request(:get, route_url(source))
        .with(headers: { 'Accept' => '*/*' })
        .to_return(status: 200, body: '', headers: {})
      @response = subject.get_routes(source)
    end

    it 'returns Faraday::Response object' do
      expect(@response).to be_kind_of(Faraday::Response)
    end

    it 'responds to status method and returns 200' do
      expect(@response.status).to be(200)
    end

    it 'responds to body method and returns empty string' do
      expect(@response.body).to be_empty
    end
  end

  describe '.post_route' do
    before do
      @payload = {
        source: :sentinels,
        start_node: :alpha,
        end_node: :beta,
        start_time: Time.now.utc,
        end_time: Time.now.utc,
        passphrase: Leo.passphrase
      }

      stub_post_route(request_body: @payload.to_json)
    end

    context 'when the payload argument is JSON string' do
      before do
        @response = subject.post_route(@payload.to_json)
      end

      it 'returns Faraday::Response object' do
        expect(@response).to be_kind_of(Faraday::Response)
      end

      it 'responds to status method and returns 200' do
        expect(@response.status).to be(200)
      end

      it 'responds to body method and returns empty string' do
        expect(@response.body).to be_empty
      end
    end

    context 'when the payload argument is Hash object' do
      before do
        @response = subject.post_route(@payload)
      end

      it 'returns Faraday::Response object' do
        expect(@response).to be_kind_of(Faraday::Response)
      end

      it 'responds to status method and returns 200' do
        expect(@response.status).to be(200)
      end

      it 'responds to body method and returns empty string' do
        expect(@response.body).to be_empty
      end
    end
  end

  describe '.routes_path' do
    context 'when the source argument is nil' do
      it 'produces the path' do
        path = '/the_one/routes'
        expect(subject.routes_path).to eql(path)
      end
    end

    context 'when the source argument is NOT nil' do
      it 'produces the path' do
        source = 'sentinels'
        path = format('/the_one/routes?source=%<source>s', source: source)
        expect(subject.routes_path(source)).to eql(path)
      end
    end
  end
end
