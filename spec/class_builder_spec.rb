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

  let(:class_name) { :SomeClass }

  before { allow(subject).to receive(:java_import).and_return('') }

  %i[build_class build_classes].each do |method|
    it "defines .#{method} if included" do
      expect(subject).to respond_to method
    end
  end

  describe '.build_class' do
    it 'runs java_import with the right resolved class path' do
      class_path = "some.weka.customCamelCased.module.#{class_name}"

      expect(subject).to receive(:java_import).once.with(class_path)
      subject.build_class(class_name)
    end

    describe 'concerns' do
      let(:built_class) { subject.build_class(class_name) }

      describe 'built class including Describable functionality' do
        Weka::Concerns::Describable::ClassMethods.instance_methods.each do |method|
          it "responds to .#{method}" do
            expect(built_class).to respond_to method
          end
        end
      end

      describe 'built class including Buildable functionality' do
        Weka::Concerns::Buildable::ClassMethods.instance_methods.each do |method|
          it "responds to .#{method}" do
            expect(built_class).to respond_to method
          end
        end
      end

      describe 'built class including Optionizable functionality' do
        let(:built_class_instance) { built_class.new }

        it 'responds to .default_options' do
          expect(built_class).to respond_to :default_options
        end

        %i[use_options options].each do |method|
          it "responds to ##{method}" do
            expect(built_class_instance).to respond_to method
          end
        end
      end
    end

    context 'with defined Utils' do
      before do
        module Some
          module Weka
            module Utils
              def shared_method; end
            end
          end
        end
      end

      it 'includes them in the defined class' do
        built_class = subject.build_class(class_name)
        expect(built_class.public_method_defined?(:shared_method)).to be true
      end
    end

    context 'without defined Utils' do
      subject do
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
        class_definition = "class #{class_name}; end"

        allow(subject)
          .to receive(:java_import)
          .and_return(subject.module_eval(class_definition, __FILE__, __LINE__))
      end

      it 'does not include extra methods in the defined class' do
        built_class = subject.build_class(class_name)
        expect(built_class.public_method_defined?(:shared_method)).to be false
      end
    end

    context 'with a defined Weka module' do
      let(:weka_module) { 'explicitly.defined.module' }

      it 'imports the given classes from the defined module' do
        class_path = "#{weka_module}.#{class_name}"

        expect(subject).to receive(:java_import).once.with(class_path)
        subject.build_class(class_name, weka_module: weka_module)
      end
    end
  end

  describe '.build_classes' do
    context 'without a given weka_module' do
      it 'runs .build_class for each of the given classes' do
        class_names = %i[SomeClass SomeOtherClass]

        expect(subject)
          .to receive(:build_class)
          .exactly(class_names.count).times

        subject.build_classes(*class_names)
      end
    end

    context 'with a given weka_module' do
      it 'runs .build_class for each of the given classes' do
        class_names = %i[SomeClass SomeOtherClass]

        expect(subject)
          .to receive(:build_class)
          .exactly(class_names.count).times

        subject.build_classes(*class_names, weka_module: 'weka.module')
      end
    end
  end
end
