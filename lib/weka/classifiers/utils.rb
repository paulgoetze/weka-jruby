require 'weka/core/serialization_helper'
require 'weka/classifiers/evaluation'
require 'weka/core/instances'

module Weka
  module Classifiers
    module Utils
      def self.included(base)
        base.include Buildable     if base.instance_methods.include?(:build_classifier)
        base.include Classifiable  if base.instance_methods.include?(:classify_instance)
        base.include Updatable     if base.instance_methods.include?(:update_classifier)
        base.include Distributable if base.instance_methods.include?(:distribution_for_instance)
      end

      module Checks
        private

        def ensure_class_attribute_assigned!(instances)
          return if instances.class_attribute_defined?

          error   = 'Class attribute is not assigned for Instances.'
          hint    = 'You can assign a class attribute with #class_attribute=.'
          message = "#{error}\n#{hint}"

          raise UnassignedClassError, message
        end

        def ensure_trained_with_instances!
          return unless training_instances.nil?

          error   = 'Classifier is not trained with Instances.'
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

          message = 'The passed instances need to have the same structure as ' +
                    'the classifier’s training instances.'

          raise InvalidInstancesStructureError, message
        end

        def ensure_instances_structure_available!
          return unless instances_structure.nil?

          error   = "Classifier does not have any instances structure info."
          hint    = 'You probably tried to classify values with a classifier ' +
                    'that is untrained or doesn’t have an instances_structure ' +
                    'set. Please run #train_with_instances, try serializing ' +
                    'and deserializing your classifier again in case you used ' +
                    'a deserialized classifier or set its instances_structure.'
          message = "#{error}\n#{hint}"

          raise MissingInstancesStructureError, message
        end
      end

      module Transformers
        private

        def classifiable_instance_from(instance_or_values)
          instances = instances_structure.copy
          instances.add_instance(instance_or_values)

          instance = instances.first
          instance.set_class_missing
          instance
        end
      end

      module Buildable
        java_import 'java.util.Random'
        include Checks

        attr_reader :training_instances
        attr_reader :instances_structure

        def train_with_instances(instances)
          ensure_class_attribute_assigned!(instances)

          @training_instances = instances
          @instances_structure = instances.string_free_structure

          build_classifier(instances)

          self
        end

        def instances_structure=(instances)
          ensure_valid_instances_structure!(instances)
          @instances_structure = instances.string_free_structure
        end

        def cross_validate(folds: 3)
          ensure_trained_with_instances!

          evaluation = Evaluation.new(training_instances)
          random     = Java::JavaUtil::Random.new(1)

          evaluation.cross_validate_model(
            self,
            training_instances,
            folds.to_i,
            random
          )

          evaluation
        end

        def evaluate(test_instances)
          ensure_trained_with_instances!
          ensure_class_attribute_assigned!(test_instances)

          evaluation = Evaluation.new(training_instances)
          evaluation.evaluate_model(self, test_instances)
          evaluation
        end
      end

      module Classifiable
        include Checks
        include Transformers

        def classify(instance_or_values)
          ensure_instances_structure_available!

          instance = classifiable_instance_from(instance_or_values)
          index    = classify_instance(instance)

          class_value_of_index(index)
        end

        private

        def class_value_of_index(index)
          instances_structure.class_attribute.value(index)
        end
      end

      module Updatable
        def add_training_instance(instance)
          training_instances.add(instance)
          update_classifier(instance)

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

          instance      = classifiable_instance_from(instance_or_values)
          distributions = distribution_for_instance(instance)

          class_distributions_from(distributions)
        end

        private

        def class_distributions_from(distributions)
          class_values = instances_structure.class_attribute.values

          distributions.each_with_object({}).with_index do |(distribution, result), index|
            class_value = class_values[index]
            result[class_value] = distribution
            result
          end
        end
      end
    end
  end
end
