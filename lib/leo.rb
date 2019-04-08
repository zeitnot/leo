# frozen_string_literal: true

require 'leo/version'
require 'zip'
require 'csv'
require 'faraday'
require 'logger'
require 'json'

require 'leo/errors'
require 'leo/util'
require 'leo/route_client'
require 'leo/source'

# Parser classes
require 'leo/parser'
require 'leo/parsers/base'
require 'leo/parsers/sentinels'
require 'leo/parsers/sniffers'
require 'leo/parsers/loopholes'

# Managers
require 'leo/post_manager'
require 'leo/extract_manager'
require 'leo/download_manager'

module Leo # :nodoc:
  SOURCES = %i[sentinels sniffers loopholes].freeze
  @cache_lifetime = 300 # 5 Minutes
  @download_path  = Pathname.new 'tmp'

  # Passwords or API Keys should be stored in environment variables.
  # But for this case study it is not important as much.
  @passphrase           = 'Kans4s-i$-g01ng-by3-bye'
  @route_base           = 'https://challenge.distribusion.com'
  @max_network_retries  = 3
  @open_timeout         = 10
  @read_timeout         = 30

  class << self
    attr_reader :route_base, :passphrase, :download_path, :cache_lifetime, :max_network_retries,
                :open_timeout, :read_timeout

    # Lists routes for every sources.
    # @param [String, Symbol] sources
    # @return [Hash]
    def list_routes(*sources)
      PostManager.new(*sources).routes
    end

    # Post routes for every sources.
    # @param [String, Symbol] sources
    # @return [Hash]
    def post_routes(*sources)
      PostManager.new(*sources).post_routes
    end

    # Sets cache life time in seconds
    # @raise [TypeError]
    # @param [Integer, String] seconds
    # @return [Integer]
    def cache_lifetime=(seconds)
      @cache_lifetime = Integer(seconds)
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
