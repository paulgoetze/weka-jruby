require 'weka/clusterers/cluster_evaluation'
require 'weka/core/instances'

module Weka
  module Clusterers
    module Utils
      def self.included(base)
        base.class_eval do
          java_import 'java.util.Random'

          if instance_methods.include?(:build_clusterer)
            attr_reader :training_instances

            def train_with_instances(instances)
              @training_instances = instances
              build_clusterer(instances)

              self
            end

            if ancestors.include?(Java::WekaClusterers::DensityBasedClusterer)
              def cross_validate(folds: 3)
                ensure_trained_with_instances!

                ClusterEvaluation.cross_validate_model(
                  self,
                  training_instances,
                  folds.to_i,
                  Java::JavaUtil::Random.new(1)
                )
              end
            end

            def evaluate(test_instances)
              ensure_trained_with_instances!

              ClusterEvaluation.new.tap do |evaluation|
                evaluation.clusterer = self
                evaluation.evaluate_clusterer(test_instances)
              end
            end
          end

          if instance_methods.include?(:cluster_instance)
            def cluster(instance_or_values)
              ensure_trained_with_instances!

              instance = clusterable_instance_from(instance_or_values)
              cluster_instance(instance)
            end
          end

          if instance_methods.include?(:update_clusterer)
            def add_training_instance(instance)
              training_instances.add(instance)
              update_clusterer(instance)

              self
            end

            def add_training_data(data)
              values   = training_instances.internal_values_of(data)
              instance = Weka::Core::DenseInstance.new(values)
              add_training_instance(instance)
            end
          end

          if instance_methods.include?(:distribution_for_instance)
            def distribution_for(instance_or_values)
              ensure_trained_with_instances!

              instance = clusterable_instance_from(instance_or_values)
              distribution_for_instance(instance).to_a
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

          def clusterable_instance_from(instance_or_values)
            attributes = training_instances.attributes
            instances  = Weka::Core::Instances.new(attributes: attributes)

            instances.add_instance(instance_or_values)
            instances.first
          end
        end
      end
    end
  end
end
