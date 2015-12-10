require 'spec_helper'

describe Weka::Classifiers::Utils do

  let(:including_class) do
    Class.new do
      def build_classifier(instances)
      end

      def update_classifier(instance)
      end

      include Weka::Classifiers::Utils
    end
  end

  subject { including_class.new.train_with_instances(instances) }

  let(:instances) do
    file      = File.expand_path('./../../support/resources/weather.arff', __FILE__)
    instances = Weka::Core::Instances.from_arff(file)

    instances.class_attribute = :play
    instances
  end

  it { is_expected.to respond_to :train_with_instances }
  it { is_expected.to respond_to :training_instances }
  it { is_expected.to respond_to :add_training_instance }
  it { is_expected.to respond_to :cross_validate }

  describe 'if included' do
    subject { Class.new }

    it 'should set __persistent__ to true' do
      expect(subject).to receive(:__persistent__=).with(true).once
      subject.include(Weka::Classifiers::Utils)
    end
  end

  describe '#train_with_instances' do
    it 'should call Java‘s #build_classifier' do
      expect(subject)
        .to receive(:build_classifier).once
        .with(instances)

      subject.train_with_instances(instances)
    end

    it 'should set the training_instances' do
      subject = including_class.new
      expect(subject.training_instances).to be_nil
      subject.train_with_instances(instances)
      expect(subject.training_instances).to eq instances
    end

    it 'should return itself' do
      expect(subject.train_with_instances(instances)).to be subject
    end

    context 'without an assigned class attribute on instances' do
      it 'should raise an UnassignedClassError' do
        file      = File.expand_path('./../../support/resources/weather.arff', __FILE__)
        instances = Weka::Core::Instances.from_arff(file)

        expect {
          including_class.new.train_with_instances(instances)
        }.to raise_error Weka::UnassignedClassError
      end
    end
  end

  describe '#cross_validate' do
    let(:folds) { 2 }

    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:cross_validate_model)
    end

    it 'should return a Weka::Classifiers::Evaluation' do
      return_value = subject.cross_validate(folds: folds)
      expect(return_value).to be_kind_of Weka::Classifiers::Evaluation
    end

    it 'should run Java‘s #cross_validate_model on an Evaluation' do
      expect_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:cross_validate_model).once

      subject.cross_validate(folds: folds)
    end
  end

end
