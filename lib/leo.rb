# frozen_string_literal: true

require 'leo/version'
require 'zip'
require 'csv'
require 'faraday'
require 'logger'
require 'leo/errors'
require 'leo/util'
require 'leo/route_client'
require 'leo/source'
require 'leo/parser'
require 'leo/parsers/base'
require 'leo/parsers/sentinels'
require 'leo/parsers/sniffers'
require 'leo/parsers/loopholes'
require 'leo/post_manager'

module Leo # :nodoc:
  SOURCES = %i[sentinels sniffers loopholes].freeze
  @cache_lifetime = 300 # 5 Minutes
  @download_path  = Pathname.new 'tmp'

  # Passwords or API Keys should be stored in environment variables.
  # But for this case study it is not important as much.
  @passphrase     = 'Kans4s-i$-g01ng-by3-bye'
  @route_base     = 'https://challenge.distribusion.com'

  class << self
    attr_reader :route_base, :passphrase, :download_path, :cache_lifetime

    # Lists routes for every resource.
    # @param [String, Symbol] source
    # @raise Leo::InvalidSource
    # @return [Hash]
    def list_routes(source = nil)
      Source.new(source).routes
    end

    # Sets cache life time in seconds
    # @raise [TypeError]
    # @param [Integer, String] seconds
    # @return [Integer]
    def cache_lifetime=(seconds)
      Integer(seconds)
    end

    # Sets download path
    # @raise [TypeError]
    # @return [Pathname] path
    def download_path=(path)
      @download_path = Pathname.new(path)
    end

    def logger
      @logger ||= Logger.new(STDOUT)
    end
  end
end
