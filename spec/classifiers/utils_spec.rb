require 'spec_helper'

describe Weka::Classifiers::Utils do
  let(:including_class) do
    Class.new do
      def build_classifier(instances); end

      def update_classifier(instance); end

      def classify_instance; end

      def distribution_for_instance; end

      include Weka::Classifiers::Utils
    end
  end

  let(:instances) do
    instances = load_instances('weather.arff')
    instances.class_attribute = :play
    instances
  end

  subject { including_class.new.train_with_instances(instances) }

  it { is_expected.to respond_to :train_with_instances }
  it { is_expected.to respond_to :training_instances }
  it { is_expected.to respond_to :add_training_instance }
  it { is_expected.to respond_to :cross_validate }
  it { is_expected.to respond_to :evaluate }
  it { is_expected.to respond_to :classify }
  it { is_expected.to respond_to :distribution_for }
  it { is_expected.to respond_to :instances_structure }
  it { is_expected.to respond_to :instances_structure= }

  describe '#train_with_instances' do
    it 'calls Java’s #build_classifier' do
      expect(subject).to receive(:build_classifier).once.with(instances)
      subject.train_with_instances(instances)
    end

    it 'sets the training_instances' do
      subject = including_class.new
      expect(subject.training_instances).to be_nil
      subject.train_with_instances(instances)
      expect(subject.training_instances).to eq instances
    end

    it 'returns itself' do
      expect(subject.train_with_instances(instances)).to be subject
    end

    context 'without an assigned class attribute on instances' do
      it 'raises an UnassignedClassError' do
        instances = load_instances('weather.arff')

        expect { including_class.new.train_with_instances(instances) }
          .to raise_error Weka::UnassignedClassError
      end
    end
  end

  describe '#add_training_instance' do
    let(:instance) { Weka::Core::DenseInstance.new([0, 85.0, 85.0, 1, 1]) }

    before do
      allow(subject).to receive(:update_classifier)
      subject.train_with_instances(instances)
    end

    it 'calls Java’s #update_classifier' do
      expect(subject).to receive(:update_classifier).once.with(instance)
      subject.add_training_instance(instance)
    end

    it 'adds the instance to training_instances' do
      expect { subject.add_training_instance(instance) }
        .to change { subject.training_instances.count }
        .by(1)
    end

    it 'returns itself' do
      expect(subject.add_training_instance(instance)).to be_a subject.class
    end
  end

  describe '#add_training_data' do
    let(:values) { [:sunny, 85, 85, :FALSE, :no] }

    before do
      allow(subject).to receive(:update_classifier)
      subject.train_with_instances(instances)
    end

    it 'calls #add_training_instance' do
      expect(subject)
        .to receive(:add_training_instance).once
        .with(an_instance_of(Weka::Core::DenseInstance))

      subject.add_training_data(values)
    end

    it 'returns itself' do
      expect(subject.add_training_data(values)).to be_kind_of subject.class
    end
  end

  describe '#cross_validate' do
    let(:default_folds) { 3 }

    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:cross_validate_model)
    end

    it 'returns a Weka::Classifiers::Evaluation' do
      return_value = subject.cross_validate
      expect(return_value).to be_kind_of Weka::Classifiers::Evaluation
    end

    it 'runs Java’s #cross_validate_model on an Evaluation' do
      expect_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:cross_validate_model).once

      subject.cross_validate
    end

    it 'uses 3 folds and the training instances as default test instances' do
      expect_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:cross_validate_model).once
        .with(
          subject,
          subject.training_instances,
          default_folds,
          an_instance_of(Java::JavaUtil::Random)
        )

      subject.cross_validate
    end

    context 'with given folds' do
      let(:folds) { default_folds + 1 }

      it 'uses the given number of folds' do
        expect_any_instance_of(Weka::Classifiers::Evaluation)
          .to receive(:cross_validate_model).once
          .with(
            subject,
            subject.training_instances,
            folds,
            an_instance_of(Java::JavaUtil::Random)
          )

        subject.cross_validate(folds: folds)
      end

      it 'uses the folds as an integer value' do
        expect_any_instance_of(Weka::Classifiers::Evaluation)
          .to receive(:cross_validate_model).once
          .with(
            subject,
            subject.training_instances,
            2,
            an_instance_of(Java::JavaUtil::Random)
          )

        subject.cross_validate(folds: 2.75)
      end
    end

    context 'without training instances' do
      before { allow(subject).to receive(:training_instances).and_return(nil) }

      it 'raises an UnassignedTrainingInstancesError' do
        expect { subject.cross_validate }
          .to raise_error Weka::UnassignedTrainingInstancesError
      end
    end
  end

  describe '#evaluate' do
    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:evaluate_model)
    end

    it 'returns a Weka::Classifiers::Evaluation' do
      return_value = subject.evaluate(instances)
      expect(return_value).to be_kind_of Weka::Classifiers::Evaluation
    end

    it 'runs Java’s #evaluate_model on an Evaluation' do
      expect_any_instance_of(Weka::Classifiers::Evaluation)
        .to receive(:evaluate_model).once
        .with(subject, instances)

      subject.evaluate(instances)
    end

    context 'without an assigned class attribute on test instances' do
      it 'raises an UnassignedClassError' do
        instances = load_instances('weather.arff')

        expect { subject.evaluate(instances) }
          .to raise_error Weka::UnassignedClassError
      end
    end

    context 'without training instances' do
      before { allow(subject).to receive(:training_instances).and_return(nil) }

      it 'raises an UnassignedTrainingInstancesError' do
        expect { subject.evaluate(instances) }
          .to raise_error Weka::UnassignedTrainingInstancesError
      end
    end
  end

  describe '#classify' do
    let(:instance)    { instances.first }
    let(:values)      { [:overcast, 83, 86, :FALSE, '?'] }
    let(:class_value) { 'no' }
    let(:class_index) { 1.0 }

    context 'for a newly built classifier' do
      before do
        allow(subject).to receive(:classify_instance).and_return(class_index)
      end

      context 'with a given instance' do
        it 'calls Java’s #classify_instance' do
          expect(subject)
            .to receive(:classify_instance).once
            .with(an_instance_of(instance.class))

          subject.classify(instance)
        end

        it 'returns the predicted class value of the instance' do
          expect(subject.classify(instance)).to eq class_value
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #classify_instance' do
          expect(subject)
            .to receive(:classify_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.classify(values)
        end

        it 'returns the predicted class value of the instance' do
          expect(subject.classify(values)).to eq class_value
        end
      end

      context 'without an available instances structure' do
        before do
          allow(subject).to receive(:instances_structure).and_return(nil)
        end

        it 'raises a MissingInstancesStructureError' do
          expect { subject.classify(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end

    context 'for a deserialized classifier' do
      subject do
        classifier = Weka::Classifiers::Bayes::NaiveBayes.new
        classifier.train_with_instances(instances)

        filename = temp_file('test.model')
        classifier.serialize(filename)
        Weka::Core::SerializationHelper.deserialize(filename)
      end

      before do
        allow(subject).to receive(:classify_instance).and_return(class_index)
      end

      after { remove_temp_dir }

      context 'with a given instance' do
        it 'calls Java’s #classify_instance' do
          expect(subject)
            .to receive(:classify_instance).once
            .with(an_instance_of(instance.class))

          subject.classify(instance)
        end

        it 'returns the predicted class value of the instance' do
          expect(subject.classify(instance)).to eq class_value
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #classify_instance' do
          expect(subject)
            .to receive(:classify_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.classify(values)
        end

        it 'returns the predicted class value of the instance' do
          expect(subject.classify(values)).to eq class_value
        end
      end

      context 'without an available instances structure' do
        before do
          allow(subject).to receive(:instances_structure).and_return(nil)
        end

        it 'raises a MissingInstancesStructureError' do
          expect { subject.classify(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end
  end

  describe '#distribution_for' do
    let(:instance)            { instances.first }
    let(:values)              { [:overcast, 83, 86, :FALSE, '?'] }
    let(:distributions)       { [0.543684388757196, 0.4563156112428039] }
    let(:class_distributions) { { 'yes' => distributions[0], 'no' => distributions[1] } }

    before do
      allow(subject)
        .to receive(:distribution_for_instance)
        .and_return(distributions)
    end

    context 'for a newly build classifier' do
      context 'with a given instance' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(instance.class))

          subject.distribution_for(instance)
        end

        it 'returns the predicted class distributions of the instance' do
          expect(subject.distribution_for(instance)).to eq class_distributions
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values)
        end

        it 'returns the predicted class distributions of the instance' do
          expect(subject.distribution_for(values)).to eq class_distributions
        end
      end

      context 'without an available instances structure' do
        before do
          allow(subject).to receive(:instances_structure).and_return(nil)
        end

        it 'raises a MissingInstancesStructureError' do
          expect { subject.distribution_for(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end

    context 'for a deserialized classifier' do
      subject do
        classifier = Weka::Classifiers::Bayes::NaiveBayes.new
        classifier.train_with_instances(instances)

        filename = temp_file('test.model')
        classifier.serialize(filename)
        Weka::Core::SerializationHelper.deserialize(filename)
      end

      after { remove_temp_dir }

      context 'with a given instance' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(instance.class))

          subject.distribution_for(instance)
        end

        it 'returns the predicted class distributions of the instance' do
          expect(subject.distribution_for(instance)).to eq class_distributions
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values)
        end

        it 'returns the predicted class distributions of the instance' do
          expect(subject.distribution_for(values)).to eq class_distributions
        end
      end

      context 'without an available instances structure' do
        before do
          allow(subject).to receive(:instances_structure).and_return(nil)
        end

        it 'raises a MissingInstancesStructureError' do
          expect { subject.distribution_for(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end
  end

  describe '#instances_structure' do
    context 'for a trained classifier' do
      it 'returns the structure of the training dataset' do
        structure = subject.instances_structure

        expect(structure).to be_kind_of Weka::Core::Instances
        expect(structure).to eq subject.training_instances.string_free_structure
      end
    end

    context 'for an untrained classifier' do
      it 'returns nil' do
        expect(including_class.new.instances_structure).to be_nil
      end
    end
  end

  describe '#instances_structure=' do
    context 'for a different structure than the training data' do
      it 'raises an InvalidInstancesStructureError' do
        expect { subject.instances_structure = Weka::Core::Instances.new }
          .to raise_error Weka::InvalidInstancesStructureError
      end
    end

    context 'when passing a non-Weka::Core::Instance' do
      it 'raises a ValueError' do
        expect { subject.instances_structure = 'something else' }
          .to raise_error ArgumentError
      end
    end

    context 'for an untrained classifier' do
      it 'assigns the given instances header' do
        classifier = including_class.new
        classifier.instances_structure = instances
        structure = classifier.instances_structure

        expect(structure).to eq instances.string_free_structure
      end
    end
  end
end
