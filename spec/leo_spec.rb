RSpec.describe Leo do
  it 'has a version number' do
    expect(Leo::VERSION).not_to be nil
  end

  %i[passphrase route_base].each do |method|
    it "responds to #{method} method" do
      expect(Leo).to be_respond_to(method)
    end
  end
end
