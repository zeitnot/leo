require 'leo/version'
require 'leo/route_client'

module Leo # :nodoc:
  # Passwords or API Keys should be stored in environment variables.
  # But for this case study it is not important as much.
  @passphrase   = 'Kans4s-i$-g01ng-by3-bye'.freeze
  @route_base   = 'https://challenge.distribusion.com'.freeze

  class << self
    attr_reader :route_base, :passphrase
  end
end
