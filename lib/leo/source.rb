# frozen_string_literal: true

module Leo #:nodoc:
  # This class is an implementation for sources such as <tt>sentinels</tt> or <tt>sniffers</tt>
  # This class is responsible for downloading source resource, extracts it and generates available routes.
  # @example
  #   Leo::Source.new(:sentinels).routes #=> [
  #     {
  #         start_node: "alpha",
  #         end_node: "beta",
  #         start_time: "2030-12-31T13:00:01",
  #         end_time: "2030-12-31T13:00:02"
  #     }
  #   ]
  class Source
    VALID_SOURCE_TYPES = [Symbol, String].freeze

    attr_reader :download_path, :source, :source_path, :zip_name

    def initialize(source)
      unless VALID_SOURCE_TYPES.member?(source.class)
        raise InvalidSourceTypeError, 'Given source type is invalid. Available sources types are ' \
                                      "#{VALID_SOURCE_TYPES.join(',')}"
      end

      raise SourceNotAvailableError, "'#{source}' is not available." unless Leo::SOURCES.member?(source.to_sym)

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
      if download
        extract
        generate_routes
      else
        {}
      end
    end

    private

    def download
      if from_cache?
        Leo.logger.info "Reading '#{source}' files from cache."
      else
        Util.create_download_dir # Create tmp/ dir  if does not exist.
        response = RouteClient.get_routes(source)
        return false unless response # it is nil in case of a connection error

        File.open(zip_name, 'wb') { |file| file.write(response.body) }
      end
      true
    end

    def extract
      ExtractManager.new(self).extract
    end

    def from_cache?
      zip_name.file? && Time.now - zip_name.mtime < Leo.cache_lifetime
    end

    def generate_routes
      Parser.new(self).routes
    end
  end
end
