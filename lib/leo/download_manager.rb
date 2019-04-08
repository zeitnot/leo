# frozen_string_literal: true

module Leo
  # This class is responsible for downloading zip files coming from <code>Leo::Source</code> object.
  class DownloadManager
    attr_accessor :source
    attr_reader :response

    # @param [Leo::Source] source
    def initialize(source)
      @source = source
    end

    def download
      Util.create_download_dir # Create tmp/ dir  if does not exist.
      @response = RouteClient.get_routes(source.source)
      return false unless @response # it is nil in case of a connection error
      return false unless zip? # If the content type is not application/zip skip it
      File.open(source.zip_name, 'wb') { |file| file.write(@response.body) }
      true
    end

    def zip?
      response.headers['Content-Type'] == 'application/zip'
    end
  end
end
