module Weka
  module Concerns
    module Persistent
      def self.included(base)
        base.class_eval do
          self.__persistent__ = true if respond_to?(:__persistent__=)
        end
      end
    end
  end
end
