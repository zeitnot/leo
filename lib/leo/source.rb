# frozen_string_literal: true

module Leo #:nodoc:
  # This class is an implementation for sources such as <th>sentinels</th> or <th>sniffers</th>
  # This class is responsible for downloading source resource, extracts it and generates available routes.
  # @example
  #   Leo::Source.new(:sentinels).routes => [
  #     {
  #         start_node: "alpha",
  #         end_node: "beta",
  #         start_time: "2030-12-31T13:00:01",
  #         end_time: "2030-12-31T13:00:02"
  #     }
  #   ]
  class Source
    attr_reader :download_path, :source, :source_path, :zip_name
    def initialize(source)
      @download_path = Leo.download_path
      @source        = source.to_s
      @source_path   = @download_path + @source
      @zip_name      = @download_path + (@source + '.zip')
    end

    # Downloads and extracts the source file and generates routes
    # and returns array of hash.
    # @example
    #   routes => [
    #     {
    #         start_node: "alpha",
    #         end_node: "beta",
    #         start_time: "2030-12-31T13:00:01",
    #         end_time: "2030-12-31T13:00:02"
    #     }
    #   ]
    # @return [Hash]
    def routes
      download
      extract
      generate_routes
    end

    private

    def download
      if from_cache?
        puts 'Reading from cache'
      else
        Util.create_download_dir # Create tmp/ dir  if does not exist.
        response = RouteClient.get_routes(source)
        File.open(zip_name, 'wb') { |file| file.write(response.body) }
      end
      true
    end

    def extract
      # Remove extracted source dir recursively to fresh the data
      FileUtils.rm_rf(source_path)
      Zip::File.open(zip_name) { |zip_file| _extract(zip_file) }
      true
    end

    # :reek:FeatureEnvy
    def _extract(zip_file)
      zip_file.each do |file|
        file_name = file.name
        next if file_name =~ /__MACOSX/i

        path = File.join(download_path, file_name)
        zip_file.extract(file, path)
      end
    end

    def from_cache?
      zip_name.file? && Time.now - zip_name.mtime < Leo.cache_lifetime
    end

    # TODO: Implement route generator.
    def generate_routes
      [{
          start_node: 'alpha',
          end_node: 'beta',
          start_time: '2030-12-31T13:00:01',
          end_time: '2030-12-31T13:00:02'
       }]
    end
  end
end
