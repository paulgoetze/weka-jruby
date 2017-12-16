require 'weka/clusterers/cluster_evaluation'
require 'weka/core/instances'

module Weka
  module Clusterers
    module Utils
      def self.included(base)
        if base.instance_methods.include?(:build_clusterer)
          base.include Buildable
          base.include CrossValidatable if density_based?(base)
        end

        base.include Clusterable   if base.instance_methods.include?(:cluster_instance)
        base.include Updatable     if base.instance_methods.include?(:update_clusterer)
        base.include Distributable if base.instance_methods.include?(:distribution_for_instance)
      end

      def self.density_based?(base)
        base.ancestors.include?(Java::WekaClusterers::DensityBasedClusterer)
      end

      module Checks
        private

        def ensure_trained_with_instances!
          return unless training_instances.nil?

          error   = 'Clusterer is not trained with Instances.'
          hint    = 'You can set the training instances with #train_with_instances.'
          message = "#{error}\n#{hint}"

          raise UnassignedTrainingInstancesError, message
        end

        def ensure_valid_instances_structure!(instances)
          unless instances.is_a?(Weka::Core::Instances)
            message = 'Instances has to be a Weka::Core::Instances object.'
            raise ArgumentError, message
          end

          return if training_instances.nil?
          return if instances.equal_headers(training_instances)

          message = 'The passed instances need to have the same structure as ' \
                    'the clusterers training instances.'

          raise InvalidInstancesStructureError, message
        end

        def ensure_instances_structure_available!
          return unless instances_structure.nil?

          error   = 'Clusterer does not have any instances structure info.'
          hint    = 'You probably tried to cluster values with a clusterer ' \
                    'that is untrained or doesn’t have an ' \
                    'instances_structure set. Please run ' \
                    '#train_with_instances, try serializing and ' \
                    'deserializing your clusterer again in case you used a ' \
                    'deserialized clusterer or set its instances_structure.'
          message = "#{error}\n#{hint}"

          raise MissingInstancesStructureError, message
        end
      end

      module Transformers
        private

        def clusterable_instance_from(instance_or_values)
          instances = instances_structure.copy
          instances.add_instance(instance_or_values)
          instances.first
        end
      end

      module Buildable
        include Checks

        attr_reader :training_instances
        attr_reader :instances_structure

        def train_with_instances(instances)
          @training_instances = instances
          @instances_structure = instances.string_free_structure

          build_clusterer(instances)

          self
        end

        def instances_structure=(instances)
          ensure_valid_instances_structure!(instances)
          @instances_structure = instances.string_free_structure
        end

        def evaluate(test_instances)
          ensure_trained_with_instances!

          ClusterEvaluation.new.tap do |evaluation|
            evaluation.clusterer = self
            evaluation.evaluate_clusterer(test_instances)
          end
        end
      end

      module CrossValidatable
        java_import 'java.util.Random'
        include Checks

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

      module Clusterable
        include Checks
        include Transformers

        def cluster(instance_or_values)
          ensure_instances_structure_available!

          instance = clusterable_instance_from(instance_or_values)
          cluster_instance(instance)
        end
      end

      module Updatable
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

      module Distributable
        include Checks
        include Transformers

        def distribution_for(instance_or_values)
          ensure_instances_structure_available!

          instance = clusterable_instance_from(instance_or_values)
          distribution_for_instance(instance).to_a
        end
      end
    end
  end
end
