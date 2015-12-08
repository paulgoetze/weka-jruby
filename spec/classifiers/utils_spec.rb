require 'spec_helper'

describe Weka::Classifiers::Utils do

  let(:including_class) do
    Class.new do
      def build_classifier
      end

      include Weka::Classifiers::Utils
    end
  end

  subject { including_class.new }

  it { is_expected.to respond_to :train_with_instances }

  describe 'aliases:' do
    {
      train_with_instances:  :build_classifier
    }.each do |alias_method, method|
      it "should define the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end

  describe 'if included' do
    subject { Class.new }

    it 'should set __persistent__ to true' do
      expect(subject).to receive(:__persistent__=).with(true).once
      subject.include(Weka::Classifiers::Utils)
    end
  end

end
