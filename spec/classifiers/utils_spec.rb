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

  it 'should respond to .build' do
    expect(including_class).to respond_to :build
  end

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

  describe '.build' do
    context 'called with a block' do
      before do
        allow_any_instance_of(including_class).to receive(:a_public_method)
      end

      it 'should evaluate the given block on a new class instance' do
        expect_any_instance_of(including_class).to receive(:a_public_method).once
        including_class.build { a_public_method }
      end

      it "should return an instance of the including class" do
        instance = including_class.build { a_public_method }
        expect(instance).to be_kind_of including_class
      end
    end

    context 'called without a block' do
      it 'should return an instance of the including class' do
        expect(including_class.build).to be_kind_of including_class
      end
    end
  end

end
