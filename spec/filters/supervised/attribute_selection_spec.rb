require 'spec_helper'

describe Weka::Filters::Supervised::Attribute::AttributeSelection do
  describe 'aliases:' do
    {
      set_evaluator: :use_evaluator,
      set_search:    :use_search
    }.each do |method, alias_method|
      it "defines the alias ##{alias_method} for ##{method}" do
        expect(subject.method(method)).to eq subject.method(alias_method)
      end
    end
  end
end
