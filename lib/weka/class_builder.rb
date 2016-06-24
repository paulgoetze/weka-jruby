#require 'active_support/core_ext/module'
require 'weka/concerns'

module Weka
  module ClassBuilder
    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def build_class(class_name, weka_module: nil, include_concerns: true)
        java_import java_class_path(class_name, weka_module)
        define_class(class_name, weka_module, include_concerns: include_concerns)
      end

      def build_classes(*class_names, weka_module: nil, include_concerns: true)
        class_names.each do |name|
          build_class(name, weka_module: weka_module, include_concerns: include_concerns)
        end
      end

      private

      def java_class_path(class_name, weka_module)
        if weka_module
          "#{weka_module}.#{class_name}"
        else
          [*java_super_modules, java_including_module, class_name].compact.join('.')
        end
      end

      def java_super_modules
        super_modules.split('::').map do |name|
          downcase_first_char(name)
        end
      end

      def super_modules
        toplevel_module? ? name : deconstantize(name)
      end

      def deconstantize(name)
        name.split('::')[0...-1].join('::')
      end

      def java_including_module
        downcase_first_char(including_module)
      end

      def including_module
        demodulize(name) unless toplevel_module?
      end

      def demodulize(name)
        name.split('::').last
      end

      def toplevel_module?
        name.scan('::').count == 1
      end

      def define_class(class_name, weka_module, include_concerns: true)
        module_eval <<-CLASS_DEFINITION, __FILE__, __LINE__ + 1
          class #{class_name}
            #{'include Concerns' if include_concerns}
            #{include_serializable_for(class_name, weka_module)}
            #{include_utils}
          end
        CLASS_DEFINITION
      end

      def include_serializable_for(class_name, weka_module)
        class_path   = java_class_path(class_name, weka_module)
        serializable = Weka::Core::SerializationHelper.serializable?(class_path)

        'include Weka::Concerns::Serializable' if serializable
      end

      def include_utils
        return unless utils_defined?
        "include #{utils}"
      end

      def utils_defined?
        constantize(utils_super_modules).const_defined?(:Utils)
      end

      def constantize(module_names)
        Object.module_eval("::#{module_names}")
      end

      def utils
        "::#{utils_super_modules}::Utils"
      end

      def utils_super_modules
        super_modules.split('::')[0..1].join('::')
      end

      def downcase_first_char(string)
        return if string.nil? || string.empty?
        string[0].downcase + string[1..-1]
      end
    end
  end
end
