require 'active_support/concern'

module Weka
  module Concerns
    module Persistent
      extend ActiveSupport::Concern

      included do
        self.__persistent__ = true if respond_to?(:__persistent__=)
      end
    end
  end
end
