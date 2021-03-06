RSpec.describe  Leo::PostManager do
  subject { Leo::PostManager }

  around do |example|
    Leo::Util.clear_download_dir
    example.run
    Leo::Util.clear_download_dir
  end

  describe '#initialize' do
    context 'when argument is given' do
      it 'returns given sources' do
        expect(subject.new(:sentinels).sources).to eql([:sentinels])
      end
    end

    context 'when argument is NOT given' do
      it 'it returns all sources by default' do
        expect(subject.new.sources).to eql(Leo::SOURCES)
      end
    end
  end

  describe '#routes' do
    it 'consolidates routes' do
      Leo::SOURCES.each { |source| stub_get_zip_data(source) }
      manager = subject.new
      manager.routes{ |key,value|  expect(value).to eql(send("#{key}_routes")) }
    end
  end

  describe '#post_routes' do
    context 'when remote server returns 201 status code' do
      it 'posts routes and returns empty hash' do
        source = :sentinels
        manager = subject.new(source)
        stub_get_zip_data(source)
        stub_post_routes(source)
        expect(manager.post_routes).to eql({})
      end
    end

    context 'when remote server returns other than 201 status code' do
      it 'returns failed routes as hash' do
        source = :sentinels
        manager = subject.new(source)
        stub_get_zip_data(source)
        stub_post_routes(source, status: 400)
        expect(manager.post_routes).to eql({ [:sentinels, 'alpha', 'beta']=>false,
                                                      [:sentinels, 'beta', 'gamma']=>false,
                                                      [:sentinels, 'delta', 'beta']=>false
                                                    })
      end
    end
  end

  def stub_post_routes(source, status: 201)
    send("#{source}_routes").map do |route|
      stub_post_route(
        request_body: route.merge(source: source, passphrase: Leo::passphrase).to_json,
        status: status
      )
    end
  end

  def stub_get_zip_data(source)
    zip_data        = File.read(Pathname.new("spec/data/#{source}.zip"), mode: 'rb')
    stub_request(:get, route_url(source))
        .with(headers: { 'Accept' => '*/*' })
        .to_return(status: 200, body: zip_data, headers: { 'Content-Type' => 'application/zip' } )
  end
end