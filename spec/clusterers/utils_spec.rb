require 'spec_helper'

describe Weka::Clusterers::Utils do

  let(:including_class) do
    Class.new do
      def build_clusterer(instances)
      end

      def classify_instance
      end

      include Weka::Clusterers::Utils
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
  it { is_expected.to respond_to :cross_validate }
  it { is_expected.to respond_to :evaluate }

  describe '#train_with_instances' do
    it 'should call Java‘s #build_classifier' do
      expect(subject).to receive(:build_clusterer).once.with(instances)
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
  end

  describe '#cross_validate' do
    let(:default_folds)           { 3 }
    let(:cross_validation_result) { -9.99 }

    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow(Weka::Clusterers::ClusterEvaluation)
        .to receive(:cross_validate_model)
        .and_return(cross_validation_result)
    end

    it 'should return a Weka::Clusterers::ClusterEvaluation' do
      return_value = subject.cross_validate
      expect(return_value).to eq cross_validation_result
    end

    it 'should run Java‘s #cross_validate_model on a ClusterEvaluation' do
      expect(Weka::Clusterers::ClusterEvaluation).to receive(:cross_validate_model).once
      subject.cross_validate
    end

    it 'should use 3 folds and the training instances as default test instances' do
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

      it 'should use the given number of folds' do
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

      it 'should use the folds as an integer value' do
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
      before { allow(subject).to receive(:training_instances).and_return(nil) }

      it 'should raise an UnassignedTrainingInstancesError' do
        expect { subject.cross_validate }
          .to raise_error Weka::UnassignedTrainingInstancesError
      end
    end
  end

  describe '#evaluate' do
    before do
      allow(subject).to receive(:training_instances).and_return(instances)
      allow_any_instance_of(Weka::Clusterers::ClusterEvaluation).to receive(:evaluate_clusterer)
    end

    it 'should return a Weka::Clusterers::ClusterEvaluation' do
      return_value = subject.evaluate(instances)
      expect(return_value).to be_kind_of Weka::Clusterers::ClusterEvaluation
    end

    it 'should run Java‘s #evaluate_model on an Evaluation' do
      expect_any_instance_of(Weka::Clusterers::ClusterEvaluation)
        .to receive(:evaluate_clusterer).once
        .with(instances)

      subject.evaluate(instances)
    end

    context 'without training instances' do
      before { allow(subject).to receive(:training_instances).and_return(nil) }

      it 'should raise an UnassignedTrainingInstancesError' do
        expect { subject.evaluate(instances) }
          .to raise_error Weka::UnassignedTrainingInstancesError
      end
    end
  end

end
