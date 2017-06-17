require 'weka/core/serialization_helper'

module Weka
  module Concerns
    module Serializable
      def serialize(filename)
        Weka::Core::SerializationHelper.write(filename, self)
      end
    end
  end
end
