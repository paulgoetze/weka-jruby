require 'spec_helper'

describe Weka::Classifiers::Evaluation do

  subject do
    instances = load_instances('weather.arff')
    instances.class_attribute = :play
    Weka::Classifiers::Evaluation.new(instances)
  end

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
    }.each do |alias_method, method|
      it "should define the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end
end
