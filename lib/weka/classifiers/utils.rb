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
            @training_instances = instances
            build_classifier(instances)

            self
          end

          def cross_validate(folds: 3)
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
          alias :add_training_instance :update_classifier
        end

        if self.respond_to?(:__persistent__=)
          self.__persistent__ = true
        end
      end

    end
  end
end
