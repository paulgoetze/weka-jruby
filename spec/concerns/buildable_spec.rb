require 'spec_helper'

describe Weka::Concerns::Buildable do

  subject do
    Class.new { include Weka::Concerns::Buildable }
  end

  it 'should respond to .build' do
    expect(subject).to respond_to :build
  end

  describe '.build' do
    context 'called with a block' do
      before do
        allow_any_instance_of(subject).to receive(:a_public_method)
      end

      it 'should evaluate the given block on a new class instance' do
        expect_any_instance_of(subject).to receive(:a_public_method).once
        subject.build { a_public_method }
      end

      it "should return an instance of the including class" do
        instance = subject.build { a_public_method }
        expect(instance).to be_kind_of subject
      end
    end

    context 'called without a block' do
      it 'should return an instance of the including class' do
        expect(subject.build).to be_kind_of subject
      end
    end
  end
end
