require 'active_support/concern'

module Weka
  module Describable
    extend ActiveSupport::Concern

    module ClassMethods

      def description
        new.global_info
      end

      def options
        descriptions = new.list_options.map do |option|
          description_for_option(option)
        end

        descriptions.join("\n")
      end

      private

      def description_for_option(option)
        "#{option.synopsis}\t#{option.description.strip}"
      end
    end
  end
end
