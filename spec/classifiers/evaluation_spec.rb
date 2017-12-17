require 'spec_helper'

describe Weka::Classifiers::Evaluation do
  let(:instances) do
    instances = load_instances('weather.arff')
    instances.class_attribute = :play
    instances
  end

  subject { Weka::Classifiers::Evaluation.new(instances) }

  it { is_expected.to be_kind_of(Java::WekaClassifiers::Evaluation) }

  describe 'aliases:' do
    {
      average_cost:                   :avg_cost,
      class_details:                  :toClassDetailsString,
      correct_count:                  :correct,
      correct_percentage:             :pct_correct,
      false_negative_count:           :num_false_negatives,
      false_positive_count:           :num_false_positives,
      fmeasure:                       :f_measure,
      incorrect_count:                :incorrect,
      incorrect_percentage:           :pct_incorrect,
      instance_count:                 :num_instances,
      summary:                        :toSummaryString,
      true_negative_count:            :num_true_negatives,
      true_positive_count:            :num_true_positives,
      unclassified_count:             :unclassified,
      unclassified_percentage:        :pct_unclassified,
      weighted_f_measure:             :weighted_fmeasure,
      cumulative_margin_distribution: :toCumulativeMarginDistributionString,
      confusion_matrix:               :to_matrix_string
    }.each do |alias_method, method|
      it "defines the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end

  it_behaves_like 'class builder'

  %i[
    CostCurve
    MarginCurve
    ThresholdCurve
  ].each do |class_name|
    it "defines a class #{class_name}" do
      expect(described_class.const_defined?(class_name)).to be true
    end

    describe class_name.to_s do
      let(:curve) do
        evaluation_class_name = "Weka::Classifiers::Evaluation::#{class_name}"
        Object.module_eval(evaluation_class_name, __FILE__, __LINE__).new
      end

      it 'responds to #curve' do
        expect(curve).to respond_to :curve
      end

      describe '#curve' do
        let(:classifier) do
          classifier = Weka::Classifiers::Bayes::NaiveBayes.new
          classifier.train_with_instances(instances)
          classifier
        end

        context 'without class index' do
          it 'returns Instances for predictions' do
            evaluation = classifier.cross_validate
            curve_instances = curve.curve(evaluation.predictions)

            expect(curve_instances).to be_a Weka::Core::Instances
          end
        end

        unless class_name == :MarginCurve
          context 'with class index' do
            it 'returns Instances for predictions' do
              evaluation = classifier.cross_validate

              instances.class_attribute.values.each do |value|
                class_index = instances.class_attribute.internal_value_of(value)
                curve_instances = curve.curve(evaluation.predictions, class_index)
                expect(curve_instances).to be_a Weka::Core::Instances
              end
            end
          end
        end
      end
    end
  end
end
