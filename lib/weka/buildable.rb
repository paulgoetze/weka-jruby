require 'active_support/concern'

module Weka
  module Buildable
    extend ActiveSupport::Concern

    module ClassMethods

      def build(&block)
        instance = new
        instance.instance_eval(&block) if block_given?
        instance
      end
    end

  end
end
