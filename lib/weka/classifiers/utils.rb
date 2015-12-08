require 'active_support/concern'

module Weka
  module Classifiers
    module Utils
      extend ActiveSupport::Concern

      included do
        def self.build(&block)
          instance = new
          instance.instance_eval(&block) if block_given?
          instance
        end

        if instance_methods.include?(:build_classifier)
          alias :train_with_instances :build_classifier
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
