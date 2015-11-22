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
          include_utils_in(class_name)
        end

        def build_classes(*class_names)
          class_names.each { |name| build_class(name) }
        end

        private

        def java_class_path(class_name)
          [*java_super_modules, java_including_module, class_name].join('.')
        end

        def java_super_modules
          super_modules.downcase.split('::')
        end

        def super_modules
          self.name.deconstantize
        end

        def java_including_module
          including_module.downcase
        end

        def including_module
          self.name.demodulize
        end

        def include_utils_in(class_name)
          return unless utils_defined?

          module_eval <<-CLASS_DEFINITION, __FILE__, __LINE__ + 1
            class #{class_name}
              include #{utils}
            end
          CLASS_DEFINITION
        end

        def utils_defined?
          utils_super_modules.constantize.const_defined?(:Utils)
        end

        def utils
          "::#{utils_super_modules}::Utils"
        end

        def utils_super_modules
          super_modules.split('::')[0...2].join('::')
        end
      end
    end

  end
end
