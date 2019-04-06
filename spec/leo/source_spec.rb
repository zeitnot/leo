RSpec.describe Leo::Source do
  subject { Leo::Source }

  around do |example|
    Leo::Util.clear_download_dir
    example.run
    Leo::Util.clear_download_dir
  end

  describe '#download' do
    context 'when from_cache? returns false' do
      Leo::SOURCES.each do |source|
        source = source.to_s
        it "downloads #{source}.zip" do

          zip_data        = File.read(Pathname.new("spec/data/#{source}.zip"), mode: 'rb')
          mock_response   = double(Faraday::Response, body: zip_data)
          allow(Leo::RouteClient).to receive(:get_routes).and_return(mock_response)

          source_object = subject.new(source)
          expect(source_object.send(:from_cache?)).to be(false)
          expect(source_object.send(:download)).to be(true)
        end
      end
    end

    context 'when from_cache? returns true' do
      it 'does not download' do
        source_object = subject.new(Leo::SOURCES.first)
        allow(source_object).to receive(:from_cache?).and_return(true)
        expect(source_object.send(:download)).to be(true)
      end
    end
  end

  describe '#extract' do
    Leo::SOURCES.each do |source|
      source = source.to_s
      it "extracts #{source}.zip file" do
        FileUtils.cp(Pathname.new("spec/data/#{source}.zip"), Pathname.new(Leo.download_path))
        source_path = Leo.download_path + source
        expect(Pathname.new(source_path)).to_not be_directory

        source_object = Leo::Source.new(source)
        expect(source_object.send(:extract)).to be(true)
        expect(Pathname.new(source_path)).to be_directory
      end
    end
  end

  describe '#from_cache?' do
    let(:source_object) { subject.new 'sentinels' }

    context 'when file exists' do
      let(:mock_pathname) { double(Pathname, file?: true, mtime: Time.now ) }

      before do
        allow(source_object).to receive(:zip_name).and_return(mock_pathname)
      end

      context 'and cache life time is expired' do
        it 'returns true' do
          allow(Leo).to receive(:cache_lifetime).and_return(-1)
          expect(source_object.send(:from_cache?)).to be(false)
        end
      end

      context 'and cache life time is NOT expired' do
        it 'returns true' do
          allow(Leo).to receive(:cache_lifetime).and_return(mock_pathname.mtime.to_i + 20 )
          expect(source_object.send(:from_cache?)).to be(true)
        end
      end
    end

    context 'when file does not exist' do
      it 'returns false' do
        mock_pathname = double(Pathname, file?: false)
        allow(source_object).to receive(:zip_name).and_return(mock_pathname)
        expect(source_object.zip_name).to_not be_file
        expect(source_object.send(:from_cache?)).to be(false)
      end
    end
  end
end