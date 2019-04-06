# frozen_string_literal: true

module Leo # :nodoc:
  # Utility Functions
  module Util
    class << self
      # Removes download directory recursively.
      # @return [void]
      def remove_download_dir
        FileUtils.rm_rf(Leo.download_path)
      end

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
    end
  end
end
