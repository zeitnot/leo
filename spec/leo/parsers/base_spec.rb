RSpec.describe Leo::Parsers::Base do
  subject {Leo::Parsers::Base }

  describe '#generate_routes' do
    it 'raises MethodNotImplementedError exception' do
      object = subject.new(nil)
      expect{ object.send(:generate_routes) }.to raise_error(Leo::MethodNotImplementedError)
    end
  end
end