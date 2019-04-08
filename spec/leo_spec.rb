RSpec.describe Leo do
  it 'has a version number' do
    expect(Leo::VERSION).not_to be nil
  end

  %i[
      passphrase route_base list_routes post_routes download_path cache_lifetime
      max_network_retries open_timeout read_timeout
    ].each do |method|
    it "responds to #{method} method" do
      expect(Leo).to be_respond_to(method)
    end
  end

  it 'has list_routes and returns hash' do
    allow_any_instance_of(Leo::PostManager).to receive(:routes).and_return({})
    expect(Leo.list_routes).to eql({})
  end

  it 'has post_routes and returns hash' do
    allow_any_instance_of(Leo::PostManager).to receive(:post_routes).and_return({})
    expect(Leo.post_routes).to eql({})
  end

  it 'has cache_lifetime= and returns integer' do
    Leo.cache_lifetime = 4
    expect(Leo.cache_lifetime).to be(4)
  end

  it 'has download_path= and return Pathname object' do
    Leo.download_path = 'test'
    download_path = Leo.download_path
    expect(download_path).to be_kind_of(Pathname)
    expect(download_path.to_s).to eql('test')
  end
end
