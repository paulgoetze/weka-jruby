module Weka
  module Concerns
    module Buildable
      def self.included(base)
        base.extend ClassMethods
      end

      module ClassMethods
        def build(&block)
          instance = new
          instance.instance_eval(&block) if block_given?
          instance
        end
      end
    end
  end
end
