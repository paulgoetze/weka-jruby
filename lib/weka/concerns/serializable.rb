require 'active_support/concern'
require 'weka/core/serialization_helper'

module Weka
  module Concerns
    module Serializable
      extend ActiveSupport::Concern

      included do
        def serialize(filename)
          Weka::Core::SerializationHelper.write(filename, self)
        end
      end

    end
  end
end