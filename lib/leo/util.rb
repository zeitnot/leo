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
      # @param [String, Time] time
      # @example
      #   Leo::Util.format_time('2030-12-31T22:00:01+09:00') #=> '2030-12-31T13:00:01'
      # @return [String]
      def format_time(time)
        time = time.to_s if time.is_a?(Time)
        DateTime.parse(time).to_time.utc.strftime('%Y-%m-%dT%H:%M:%S')
      end

      # @param [Pathanme] file
      # @return [Array]
      def parse_csv_file(file)
        data = File.read(file)
        data.delete!('"')
        array = CSV.parse(data, col_sep: ',')
        array[1..-1] # Remove headers
      end

      # Removes download directory recursively.
      # @return [void]
      def remove_download_dir
        FileUtils.rm_rf(Leo.download_path)
      end
    end
  end
end
