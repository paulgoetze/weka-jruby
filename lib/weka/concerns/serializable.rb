require 'weka/core/serialization_helper'

module Weka
  module Concerns
    module Serializable
      def self.included(base)
        base.class_eval do
          def serialize(filename)
            Weka::Core::SerializationHelper.write(filename, self)
          end
        end
      end
    end
  end
end
