# frozen_string_literal: true

module Leo # :nodoc:
  # This is class is responsible for predicting the correct parser class
  # @example
  #   source = Leo::Source.new(:sentinels)
  #   parser = Leo::Parser.new(source)
  #   parser.parser_class #=> Leo::Parsers::Sentinels
  #   parser.routes #=> Leo::Parsers::Sentinels#routes
  class Parser
    # @param [Leo::Source] source
    def initialize(source)
      @source = source
      @parser = parser_class.new(@source)
    end

    def routes
      @parser.routes
    end

    def parser_class
      @parser_class ||= Object.const_get('Leo::Parsers::' + @source.source.capitalize)
    end
  end
end
