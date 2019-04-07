# frozen_string_literal: true

module Leo
  # This class is responsible for extracting zip files coming from <code>Leo::Source</code> object.
  class ExtractManager
    attr_accessor :source

    # @param [Leo::Source] source
    def initialize(source)
      @source = source
    end

    def extract
      # Remove extracted source dir recursively to fresh the data
      FileUtils.rm_rf(source.source_path)
      Zip::File.open(source.zip_name) do |zip_file|
        self.zip_file = zip_file
        extract_files
      end
      true
    end

    private

    attr_accessor :zip_file

    def extract_files
      zip_file.each do |file|
        file_name = file.name
        next if file_name =~ /__MACOSX/i

        path = File.join(source.download_path, file_name)
        zip_file.extract(file, path)
      end
    end
  end
end
