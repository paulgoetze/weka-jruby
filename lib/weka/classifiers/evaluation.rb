require 'weka/class_builder'
require 'weka/concerns'

module Weka
  module Classifiers
    java_import 'weka.classifiers.Evaluation'

    class Evaluation
      include ClassBuilder
      include Weka::Concerns::Persistent

      # Use both nomenclatures f_measure and fmeasure for consistency
      # due to jruby's auto method generation of 'fMeasure' to 'f_measure' and
      # 'weightedFMeasure' to 'weighted_fmeasure'.
      alias weighted_f_measure      weighted_fmeasure
      alias fmeasure                f_measure

      alias summary                 to_summary_string
      alias class_details           to_class_details_string
      alias matrix_string           to_matrix_string

      alias instance_count          num_instances
      alias correct_count           correct
      alias incorrect_count         incorrect
      alias unclassified_count      unclassified

      alias correct_percentage      pct_correct
      alias incorrect_percentage    pct_incorrect
      alias unclassified_percentage pct_unclassified

      alias true_negative_count     num_true_negatives
      alias false_negative_count    num_false_negatives
      alias true_positive_count     num_true_positives
      alias false_positive_count    num_false_positives
      alias average_cost            avg_cost

      alias cumulative_margin_distribution to_cumulative_margin_distribution_string

      module Curve
        def self.included(base)
          base.class_eval do
            alias_method :curve, :get_curve
          end
        end
      end

      build_classes :CostCurve,
                    :MarginCurve,
                    :ThresholdCurve,
                    weka_module: 'weka.classifiers.evaluation',
                    additional_includes: Curve
    end
  end
end
