require 'spec_helper'

describe Weka::ClassBuilder do

  subject do
    module Some
      module Weka
        module Module
          include ::Weka::ClassBuilder
        end
      end
    end
  end

  [:build_class, :build_classes].each do |method|
    it "should define .#{method} if included" do
      expect(subject).to respond_to method
    end
  end

  before { allow(subject).to receive(:java_import) { '' } }

  describe '.build_class' do
    it 'should run java_import with the right resolved class path' do
      class_name = :SomeClass
      class_path = "some.weka.module.#{class_name}"

      expect(subject).to receive(:java_import).once.with(class_path)
      subject.build_class(class_name)
    end
  end

  describe '.build_classes' do
    it 'should run .build_class for each of the given classes' do
      class_names = %i{ SomeClass SomeOtherClass }

      expect(subject).to receive(:build_class).exactly(class_names.count).times
      subject.build_classes(*class_names)
    end
  end
end
