# frozen_string_literal: true

module Leo
  # LeoError is the base error class that all other errors classes derive
  class LeoError < StandardError
  end

  class MethodNotImplementedError < LeoError
  end
end
