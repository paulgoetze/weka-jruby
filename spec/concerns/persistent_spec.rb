require 'spec_helper'

describe Weka::Concerns::Persistent do
  describe 'if included' do
    subject { Class.new }

    it 'should set __persistent__ to true' do
      expect(subject).to receive(:__persistent__=).with(true).once
      subject.include(Weka::Concerns::Persistent)
    end
  end
end
