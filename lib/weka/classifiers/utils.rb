require 'active_support/concern'
require 'weka/classifiers/evaluation'

module Weka
  module Classifiers
    module Utils
      extend ActiveSupport::Concern

      included do
        java_import 'java.util.Random'

        if instance_methods.include?(:build_classifier)
          attr_reader :training_instances

          def train_with_instances(instances)
            ensure_class_attribute_assigned!(instances)

            @training_instances = instances
            build_classifier(instances)

            self
          end

          def cross_validate(folds: 3)
            ensure_trained_with_instances!

            evaluation = Evaluation.new(self.training_instances)

            evaluation.cross_validate_model(
              self,
              self.training_instances,
              folds.to_i.to_java(:int),
              Java::JavaUtil::Random.new(1)
            )

            evaluation
          end
        end

        if instance_methods.include?(:update_classifier)
          def add_training_instance(instance)
            self.training_instances.add(instance)
            update_classifier(instance)

            self
          end

          def add_training_data(data)
            values   = self.training_instances.internal_values_of(data)
            instance = Weka::Core::DenseInstance.new(values)
            add_training_instance(instance)
          end
        end

        if self.respond_to?(:__persistent__=)
          self.__persistent__ = true
        end

        private

        def ensure_class_attribute_assigned!(instances)
          return if instances.class_attribute_defined?

          error   = 'Class attribute is not assigned for Instances.'
          hint    = 'You can assign a class attribute with #class_attribute=.'
          message = "#{error} #{hint}"

          raise UnassignedClassError, message
        end

        def ensure_trained_with_instances!
          return unless self.training_instances.nil?

          error   = 'Classifier is not trained with Instances.'
          hint    = 'You can set the training instances with #train_with_instances.'
          message = "#{error} #{hint}"

          raise UnassignedTrainingInstancesError, message
        end
      end

    end
  end
end
