require 'spec_helper'

describe Weka::Concerns::Serializable do
  subject do
    Class.new { include Weka::Concerns::Serializable }
  end

  let(:filename) { 'file.model' }

  it 'responds to #serialize' do
    expect(subject.new).to respond_to :serialize
  end

  describe '#serialize' do
    it 'calls Weka::Core::SerializationHelper.write' do
      expect(Weka::Core::SerializationHelper)
        .to receive(:write)
        .with(filename, subject)

      subject.new.serialize(filename)
    end
  end
end
