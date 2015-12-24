require 'active_support/concern'
require 'weka/clusterers/cluster_evaluation'
require 'weka/core/instances'

module Weka
  module Clusterers
    module Utils
      extend ActiveSupport::Concern

      included do
        java_import 'java.util.Random'

        if instance_methods.include?(:build_clusterer)
          attr_reader :training_instances

          def train_with_instances(instances)
            @training_instances = instances
            build_clusterer(instances)

            self
          end

          def cross_validate(folds: 3)
            ensure_trained_with_instances!

            ClusterEvaluation.cross_validate_model(
              self,
              training_instances,
              folds.to_i,
              Java::JavaUtil::Random.new(1)
            )
          end

          def evaluate(test_instances)
            ensure_trained_with_instances!

            ClusterEvaluation.new.tap do |evaluation|
              evaluation.clusterer = self
              evaluation.evaluate_clusterer(test_instances)
            end
          end
        end

        private

        def ensure_trained_with_instances!
          return unless training_instances.nil?

          error   = 'Clusterer is not trained with Instances.'
          hint    = 'You can set the training instances with #train_with_instances.'
          message = "#{error} #{hint}"

          raise UnassignedTrainingInstancesError, message
        end

        def classifiable_instance_from(instance_or_values)
          attributes = training_instances.attributes
          instances  = Weka::Core::Instances.new(attributes: attributes)

          class_attribute = training_instances.class_attribute
          class_index     = training_instances.class_index
          instances.insert_attribute_at(class_attribute, class_index)

          instances.class_index = training_instances.class_index
          instances.add_instance(instance_or_values)

          instance = instances.first
          instance.set_class_missing
          instance
        end

        def class_value_of_index(index)
          training_instances.class_attribute.value(index)
        end
      end

    end
  end
end

