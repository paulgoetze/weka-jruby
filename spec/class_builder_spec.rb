require 'spec_helper'

describe Weka::ClassBuilder do

  subject do
    module Some
      module Weka
        module CustomCamelCased
          module Module
            include ::Weka::ClassBuilder
          end
        end
      end
    end
  end

  [:build_class, :build_classes].each do |method|
    it "should define .#{method} if included" do
      expect(subject).to respond_to method
    end
  end

  before { allow(subject).to receive(:java_import).and_return('') }

  describe '.build_class' do
    let(:class_name){ :SomeClass }

    it 'should run java_import with the right resolved class path' do
      class_path = "some.weka.customCamelCased.module.#{class_name}"

      expect(subject).to receive(:java_import).once.with(class_path)
      subject.build_class(class_name)
    end

    it 'should include Describable functionality into the built class' do
      built_class = subject.build_class(class_name)

      Weka::Describable::ClassMethods.instance_methods.each do |method|
        expect(built_class).to respond_to method
      end
    end

    it 'should include Buildable functionality into the built class' do
      built_class = subject.build_class(class_name)

      Weka::Buildable::ClassMethods.instance_methods.each do |method|
        expect(built_class).to respond_to method
      end
    end

    it 'should include Optionizable functionality into the built class' do
      built_class = subject.build_class(class_name)

      [
        :use_options,
        :options
      ].each do |method|
        expect(built_class.new).to respond_to method
      end
    end

    context 'with defined Utils' do
      before do
        module Some
          module Weka
            module Utils
              def shared_method
              end
            end
          end
        end
      end

      it 'should include them in the defined class' do
        subject.build_class(class_name)
        built_class = "#{subject}::#{class_name}".constantize

        expect(built_class.public_method_defined?(:shared_method)).to be true
      end
    end

    context 'without defined Utils' do
      let(:subject) do
        module Some
          module Other
            module Custom
              module Module
                include ::Weka::ClassBuilder
              end
            end
          end
        end
      end

      before do
        allow(subject)
          .to receive(:java_import)
          .and_return(subject.module_eval("class #{class_name}; end"))
      end

      it 'should not include extra methods in the defined class' do
        subject.build_class(class_name)
        built_class = "#{subject}::#{class_name}".constantize

        expect(built_class.public_method_defined?(:shared_method)).to be false
      end
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
