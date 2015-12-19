require 'active_support/concern'

module Weka
  module Concerns
    module Persistent
      extend ActiveSupport::Concern

      included do
        if self.respond_to?(:__persistent__=)
          self.__persistent__ = true
        end
      end

    end
  end
end
