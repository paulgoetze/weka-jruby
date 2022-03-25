module Weka
  module Concerns
    module Optionizable
      def self.included(base)
        base.extend ClassMethods
        base.include InstanceMethods
      end

      module ClassMethods
        def default_options
          new.get_options.to_a.join(' ')
        end
      end

      module InstanceMethods
        java_import 'weka.core.Utils'

        def use_options(*single_options, **hash_options)
          joined_options = join_options(single_options, hash_options)
          options        = Java::WekaCore::Utils.split_options(joined_options)

          set_options(options)
          @options = joined_options
        end

        def options
          @options || self.class.default_options
        end

        private

        def join_options(single_options, hash_options)
          [
            join_single_options(single_options),
            join_hash_options(hash_options)
          ].reject(&:empty?).join(' ')
        end

        def join_single_options(options)
          options.map { |option| "-#{option.to_s.sub(/^-/, '')}" }.join(' ')
        end

        def join_hash_options(options)
          options.map { |key, value| "-#{key} #{value}" }.join(' ')
        end
      end
    end
  end
end
