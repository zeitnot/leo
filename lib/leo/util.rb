# frozen_string_literal: true

module Leo # :nodoc:
  # Utility Functions
  module Util
    class << self
      # Creates download directory if the directory does not exist.
      # @return [void]
      def create_download_dir
        path = Leo.download_path
        FileUtils.mkdir_p(path) unless File.exist?(path)
      end

      # Makes empty the download directory. If the directory does not exist creates it.
      # @return [void]
      def clear_download_dir
        path = Leo.download_path
        if path.directory?
          Dir[path + '*'].each { |file| FileUtils.rm_rf(Pathname.new(file)) }
        else
          create_download_dir
        end
      end

      # Converts the time into UTC format
      # @param [String] time
      # @example
      #   Leo::Util.convert_time_to_iso8601('2030-12-31T22:00:01+09:00') #=> '2030-12-31T13:00:01'
      # @return [String]
      def convert_time_to_utc(time)
        DateTime.iso8601(time).to_time.utc.strftime('%Y-%m-%dT%H:%M:%S')
      end

      # Removes download directory recursively.
      # @return [void]
      def remove_download_dir
        FileUtils.rm_rf(Leo.download_path)
      end
    end
  end
end
