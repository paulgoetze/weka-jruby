require 'spec_helper'

describe Weka::Core::SerializationHelper do

  it { is_expected.to be_kind_of Java::WekaCore::SerializationHelper }

  describe 'aliases:' do
    {
      write: :serialize,
      read:  :deserialize
    }.each do |method, alias_method|
      it "should define the alias .#{alias_method} for .#{method}" do
        expect(Weka::Core::SerializationHelper.public_class_method(method))
          .to eq Weka::Core::SerializationHelper.public_class_method(alias_method)
      end
    end
  end
end
