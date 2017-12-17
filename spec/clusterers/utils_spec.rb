require 'spec_helper'

describe Weka::Clusterers::Utils do
  let(:including_class) do
    Class.new do
      def build_clusterer(instances); end

      def update_clusterer(instance); end

      def cluster_instance; end

      def distribution_for_instance; end

      include Weka::Clusterers::Utils
    end
  end

  let(:instances) { load_instances('weather.arff') }

  subject { including_class.new.train_with_instances(instances) }

  it { is_expected.to respond_to :train_with_instances }
  it { is_expected.to respond_to :training_instances }
  it { is_expected.to respond_to :add_training_instance }
  it { is_expected.to respond_to :evaluate }
  it { is_expected.to respond_to :cluster }
  it { is_expected.to respond_to :distribution_for }
  it { is_expected.to respond_to :instances_structure }
  it { is_expected.to respond_to :instances_structure= }

  describe '#train_with_instances' do
    it 'calls Java’s #build_classifier' do
      expect(subject).to receive(:build_clusterer).once.with(instances)
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
  end

  describe '#add_training_instance' do
    let(:instance) { Weka::Core::DenseInstance.new([0, 85.0, 85.0, 1, 1]) }

    before do
      allow(subject).to receive(:update_clusterer)
      subject.train_with_instances(instances)
    end

    it 'calls Java’s #update_classifier' do
      expect(subject).to receive(:update_clusterer).once.with(instance)
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
      allow(subject).to receive(:update_clusterer)
      subject.train_with_instances(instances)
    end

    it 'calls #add_training_instance' do
      expect(subject)
        .to receive(:add_training_instance).once
        .with(an_instance_of(Weka::Core::DenseInstance))

      subject.add_training_data(values)
    end

    it 'returns itself' do
      expect(subject.add_training_data(values)).to be_a subject.class
    end
  end

  describe '#cross_validate' do
    let(:default_folds)           { 3 }
    let(:cross_validation_result) { -9.99 }

    context 'if clusterer is not density-based' do
      subject do
        test_class = Class.new do
          def build_clusterer(instances); end
          include Weka::Clusterers::Utils
        end

        test_class.new
      end

      it { is_expected.not_to respond_to :cross_validate }
    end

    context 'if clusterer is density-based' do
      subject do
        test_class = Class.new do
          include Java::WekaClusterers::DensityBasedClusterer
          def build_clusterer(instances); end
          include Weka::Clusterers::Utils
        end

        test_class.new
      end

      before do
        allow(subject).to receive(:training_instances).and_return(instances)
        allow(Weka::Clusterers::ClusterEvaluation)
          .to receive(:cross_validate_model)
          .and_return(cross_validation_result)
      end

      it { is_expected.to respond_to :cross_validate }

      it 'returns a Weka::Clusterers::ClusterEvaluation' do
        return_value = subject.cross_validate
        expect(return_value).to eq cross_validation_result
      end

      it 'runs Java’s #cross_validate_model on a ClusterEvaluation' do
        expect(Weka::Clusterers::ClusterEvaluation)
          .to receive(:cross_validate_model).once

        subject.cross_validate
      end

      it 'uses 3 folds and the training instances as default test instances' do
        expect(Weka::Clusterers::ClusterEvaluation)
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
          expect(Weka::Clusterers::ClusterEvaluation)
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
          expect(Weka::Clusterers::ClusterEvaluation)
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
        before do
          allow(subject).to receive(:training_instances).and_return(nil)
        end

        it 'raises an UnassignedTrainingInstancesError' do
          expect { subject.cross_validate }
            .to raise_error Weka::UnassignedTrainingInstancesError
        end
      end
    end
  end

  describe '#evaluate' do
    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow_any_instance_of(Weka::Clusterers::ClusterEvaluation)
        .to receive(:evaluate_clusterer)
    end

    it 'returns a Weka::Clusterers::ClusterEvaluation' do
      return_value = subject.evaluate(instances)
      expect(return_value).to be_kind_of Weka::Clusterers::ClusterEvaluation
    end

    it 'runs Java’s #evaluate_model on an Evaluation' do
      expect_any_instance_of(Weka::Clusterers::ClusterEvaluation)
        .to receive(:evaluate_clusterer).once
        .with(instances)

      subject.evaluate(instances)
    end

    context 'without training instances' do
      before { allow(subject).to receive(:training_instances).and_return(nil) }

      it 'raises an UnassignedTrainingInstancesError' do
        expect { subject.evaluate(instances) }
          .to raise_error Weka::UnassignedTrainingInstancesError
      end
    end
  end

  describe '#cluster' do
    let(:instance)     { instances.first }
    let(:values_array) { [:overcast, 83, 86, :FALSE, :yes] }
    let(:values_hash) do
      {
        outlook: :overcast,
        temperature: 83,
        humidity: 86,
        windy: :FALSE,
        play: :yes
      }
    end
    let(:cluster)  { 1 }

    context 'for a newly built clusterer' do
      before do
        allow(subject).to receive(:cluster_instance).and_return(cluster)
      end

      context 'with a given instance' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(instance.class))

          subject.cluster(instance)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(instance)).to eq cluster
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.cluster(values_array)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(values_array)).to eq cluster
        end
      end

      context 'with a given hash of values' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.cluster(values_hash)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(values_hash)).to eq cluster
        end
      end

      context 'without an available instances structure' do
        before { allow(subject).to receive(:instances_structure).and_return(nil) }

        it 'raises an MissingInstancesStructureError' do
          expect { subject.cluster(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end

    context 'for a deserialized clusterer' do
      subject do
        clusterer = Weka::Clusterers::EM.new
        clusterer.train_with_instances(instances)

        filename = temp_file('test.model')
        clusterer.serialize(filename)
        Weka::Core::SerializationHelper.deserialize(filename)
      end

      before do
        allow(subject).to receive(:cluster_instance).and_return(cluster)
      end

      context 'with a given instance' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(instance.class))

          subject.cluster(instance)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(instance)).to eq cluster
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.cluster(values_array)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(values_array)).to eq cluster
        end
      end

      context 'with a given hash of values' do
        it 'calls Java’s #cluster_instance' do
          expect(subject)
            .to receive(:cluster_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.cluster(values_hash)
        end

        it 'returns the predicted class value' do
          expect(subject.cluster(values_hash)).to eq cluster
        end
      end

      context 'without an available instances structure' do
        before { allow(subject).to receive(:instances_structure).and_return(nil) }

        it 'raises an MissingInstancesStructureError' do
          expect { subject.cluster(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end
  end

  describe '#distribution_for' do
    let(:instance)     { instances.first }
    let(:values_array) { [:overcast, 83, 86, :FALSE, :yes] }
    let(:values_hash) do
      {
        outlook: :overcast,
        temperature: 83,
        humidity: 86,
        windy: :FALSE,
        play: :yes
      }
    end
    let(:distributions) { [0.543684388757196, 0.4563156112428039] }

    context 'for a newly built clusterer' do
      before do
        allow(subject)
          .to receive(:distribution_for_instance)
          .and_return(distributions)
      end

      context 'with a given instance' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(instance.class))

          subject.distribution_for(instance)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(instance)).to eq distributions
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values_array)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(values_array)).to eq distributions
        end
      end

      context 'with a given hash of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values_hash)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(values_hash)).to eq distributions
        end
      end

      context 'without an available instances structure' do
        before { allow(subject).to receive(:instances_structure).and_return(nil) }

        it 'raises a MissingInstancesStructureError' do
          expect { subject.distribution_for(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end

    context 'for a deserialized clusterer' do
      subject do
        clusterer = Weka::Clusterers::EM.new
        clusterer.train_with_instances(instances)

        filename = temp_file('test.model')
        clusterer.serialize(filename)
        Weka::Core::SerializationHelper.deserialize(filename)
      end

      before do
        allow(subject)
          .to receive(:distribution_for_instance)
          .and_return(distributions)
      end

      context 'with a given instance' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(instance.class))

          subject.distribution_for(instance)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(instance)).to eq distributions
        end
      end

      context 'with a given array of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values_array)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(values_array)).to eq distributions
        end
      end

      context 'with a given hash of values' do
        it 'calls Java’s #distribution_for_instance' do
          expect(subject)
            .to receive(:distribution_for_instance).once
            .with(an_instance_of(Weka::Core::DenseInstance))

          subject.distribution_for(values_hash)
        end

        it 'returns the predicted cluster distributions' do
          expect(subject.distribution_for(values_hash)).to eq distributions
        end
      end

      context 'without an available instances structure' do
        before { allow(subject).to receive(:instances_structure).and_return(nil) }

        it 'raises a MissingInstancesStructureError' do
          expect { subject.distribution_for(instance) }
            .to raise_error Weka::MissingInstancesStructureError
        end
      end
    end
  end
end
