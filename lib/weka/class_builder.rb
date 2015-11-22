require 'active_support/concern'
require 'active_support/core_ext/string'
require 'active_support/core_ext/module'

module Weka
  module ClassBuilder
    extend ActiveSupport::Concern

    included do
      class << self
        def build_class(class_name)
          java_import java_class_path(class_name)
        end

        def build_classes(*class_names)
          class_names.each { |name| build_class(name) }
        end

        private

        def java_class_path(class_name)
          [*super_modules, including_module, class_name].join('.')
        end

        def including_module
          self.name.demodulize.downcase
        end

        def super_modules
          self.name.deconstantize.downcase.split('::')
        end
      end
    end

  end
end
